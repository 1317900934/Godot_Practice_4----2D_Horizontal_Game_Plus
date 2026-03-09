@tool
@icon("res://components/icons/level_transition.svg")
class_name Level_Transition
extends Node2D

# 场景切换器的可变大小
@export_range(2, 16, 1, "or_greater") var size: int = 2:
	set(v):
		size = v
		apply_area_settings()


enum SIDE {LEFT, RIGHT, TOP, BOTTOM}
# 场景切换器的方向
@export var location: SIDE = SIDE.LEFT:
	set(v):
		location = v
		apply_area_settings()


# 场景切换器的目标场景
@export_file("*.tscn") var target_level: String = ""
# 场景切换器的目标区域
@export var target_area_name: String = "Exit_1"


@onready var area_2d: Area2D = $Area2D




func _ready() -> void:
	if Engine.is_editor_hint(): return
	apply_area_settings()
	SceneManager.new_scene_ready.connect(_on_new_scene_ready)
	SceneManager.load_scene_finished.connect(_on_load_scene_finished)
	



# 物体(玩家)进入
func _on_player_entered(body: Node2D):
	# 转换场景
	SceneManager.transition_scene(target_level, target_area_name, get_offset(body), get_dir(location))



# 场景准备时执行
func _on_new_scene_ready(target_name: String, offset: Vector2):
	# 如果玩家进入点是自己,就移动玩家到自己的位置
	if target_name == name:
		var player: Player = get_tree().get_first_node_in_group("Player")
		player.global_position = global_position + offset



# 场景加载完毕后执行
func _on_load_scene_finished():
	area_2d.monitoring = false
	
	if not area_2d.body_entered.is_connected(_on_player_entered):
		area_2d.body_entered.connect(_on_player_entered)
	
	# 等待2个物理帧后再启用碰撞检测,避免玩家刚切入场景时还未移动就再次触发场景切换 
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	area_2d.monitoring = true




# 根据设定值改变场景切换器的方向和大小
func apply_area_settings():
	area_2d = get_node_or_null("Area2D")
	if not area_2d: return
	
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		area_2d.scale.y = size
		if location == SIDE.LEFT:
			area_2d.scale.x = -1
		else:
			area_2d.scale.x = 1
	else:
		area_2d.scale.x = size
		if location == SIDE.TOP:
			area_2d.scale.y = 1
		else:
			area_2d.scale.y = -1


# 获取玩家传送到自己时的偏移量
func get_offset(player: Node2D) -> Vector2:
	
	var offset: Vector2 = Vector2.ZERO
	var player_pos: Vector2 = player.global_position
	
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		offset.y = player_pos.y - self.global_position.y
		if location == SIDE.LEFT:
			offset.x = -30
		else:
			offset.x = 30
	else:
		offset.x = player_pos.x - self.global_position.x
		if location == SIDE.TOP:
			offset.y = -60
		else:
			offset.y = 60
	
	return offset


# 获取切换场景的方向
func get_dir(_location: SIDE) -> String:
	match _location:
		SIDE.LEFT:
			return "_left"
		SIDE.RIGHT:
			return "_right"
		SIDE.TOP:
			return "_top"
		SIDE.BOTTOM:
			return "_bottom"
	
	return ""
