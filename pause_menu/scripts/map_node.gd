@tool
@icon("res://components/icons/map_node.svg")
class_name Map_Node
extends Control


# 缩放倍率
const SCALE_FACTOR: float = 30


@export_file("*.tscn") var linked_scene: String: set = _on_scene_set
@export_tool_button("更新") var update_node_action = update_node

# 入口上下左右的偏移量
@export var entrance_top: Array[float] = []
@export var entrance_bottom: Array[float] = []
@export var entrance_left: Array[float] = []
@export var entrance_right: Array[float] = []

# 玩家指示器偏移量
@export var indicator_offset: Vector2 = Vector2.ZERO


@onready var label: Label = $Label
@onready var transition_blocks: Control = %Transition_Blocks


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		label.queue_free()
		create_transition_blocks()
		# 如果没有发现对应场景，就隐藏
		if not SaveManager.is_area_discovered(linked_scene):
			visible = false
		# 如果有对应场景并且是当前场景,就显示玩家指示器
		elif SceneManager.current_scene_uid == linked_scene:
			display_player_location()
	



# 在编辑器中更新显示
func _on_scene_set(value: String):
	
	if linked_scene != value:
		linked_scene = value
		if Engine.is_editor_hint():
			update_node()
	


# 更新节点样式
func update_node():
	# 创建默认的节点大小和出入口
	var new_size: Vector2 = Vector2(480, 270)
	var transitions: Array[Level_Transition] = []
	
	if ResourceLoader.exists(linked_scene):
		# 加载连接的场景资源
		var packed_scene: PackedScene = ResourceLoader.load(linked_scene) as PackedScene
		
		if packed_scene:
			# 实例化场景资源
			var instance = packed_scene.instantiate()
			
			if instance:
				# 获取场景数据后清除
				update_node_label(instance)
				for c in instance.get_children():
					if c is Level_Bounds:
						new_size = Vector2(c.width, c.height)
						indicator_offset = c.position
					elif c is Level_Transition:
						transitions.append(c)
				
				instance.queue_free()
	
	
	# 设置自己的大小
	size = (new_size / SCALE_FACTOR).round()
	# 创建出入口数据
	create_entrance_data(transitions)
	# 创建出入口区块样式
	create_transition_blocks()





# 获取对应场景的名称文本(仅在编辑器显示)
func update_node_label(scene: Node):
	if not label:
		label = $Label
	
	var t: String = scene.scene_file_path
	t = t.replace("res://levels/", "")
	t = t.replace(".tscn", "")
	label.text = t




# 创建出入口数据
func create_entrance_data(transitions: Array[Level_Transition]):
	
	# 先清空一遍可能残留的数据
	entrance_top.clear()
	entrance_bottom.clear()
	entrance_left.clear()
	entrance_right.clear()
	
	for t in transitions:
		
		var pos: Vector2 = (t.position - indicator_offset) / SCALE_FACTOR
		
		# 计算并添加出入口图形偏移量
		
		if t.location == Level_Transition.SIDE.LEFT:
			var offset: float = clampf(
				pos.y - 3, 3.0, self.size.y - 6
			)
			entrance_left.append(offset)
			
		elif t.location == Level_Transition.SIDE.RIGHT:
			var offset: float = clampf(
				pos.y - 3, 3.0, self.size.y - 6
			)
			entrance_right.append(offset)
			
		elif t.location == Level_Transition.SIDE.TOP:
			var offset: float = clampf(
				pos.x, 3.0, self.size.x - 6
			)
			entrance_top.append(offset)
			
		elif t.location == Level_Transition.SIDE.BOTTOM:
			var offset: float = clampf(
				pos.x, 3.0, self.size.x - 6
			)
			entrance_bottom.append(offset)





# 创建所有出入口区块样式
func create_transition_blocks():
	if not transition_blocks:
		transition_blocks = %Transition_Blocks
	
	# 先清空一遍可能残留的子节点
	for c in transition_blocks.get_children():
		c.queue_free()
	
	#region 遍历上下左右，设定并添加所有出入口图形
	for t in entrance_left:
		var block: ColorRect = add_block()
		block.size.y = 5
		block.position.x = 0
		block.position.y = t
	
	for t in entrance_right:
		var block: ColorRect = add_block()
		block.size.y = 5
		block.position.x = self.size.x - 2
		block.position.y = t
	
	for t in entrance_top:
		var block: ColorRect = add_block()
		block.size.x = 5
		block.position.x = t - 2
		block.position.y = 0
	
	for t in entrance_bottom:
		var block: ColorRect = add_block()
		block.size.x = 5
		block.position.x = t - 2
		block.position.y = self.size.y - 2
	#endregion



# 添加出入口矩形样式块
func add_block() -> ColorRect:
	var block: ColorRect = ColorRect.new()
	
	# 添加矩形到节点中，并设定基础大小
	transition_blocks.add_child(block)
	block.custom_minimum_size.x = 2
	block.custom_minimum_size.y = 2
	
	return block



# 在小地图区域显示玩家位置
func display_player_location():
	# 获取玩家节点
	var player: Player = get_tree().get_first_node_in_group("Player")
	# 获取玩家指示器节点(本地图节点的同级节点)
	var i: Control = %Player_Indicator
	
	# 获取自身(地图节点)的位置
	var pos: Vector2 = position
	
	# 初始化玩家指示器的位置，此时玩家指示器的位置和自身(地图节点)位置相同
	i.position = pos
	
	print(player.global_position)
	print(indicator_offset)
	
	# 附加额外偏移量，使指示器同步玩家位置
	pos += ((player.global_position - indicator_offset) / SCALE_FACTOR)
	
	# 避免指示器完全贴近边缘
	var pos_clamp: Vector2 = Vector2(3, 3)
	i.position = pos.clamp(position + pos_clamp, position + size - pos_clamp)
	
