class_name Player
extends CharacterBody2D


@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var sprite: Player_Sprite = $Sprite2D
@onready var one_way_platform_shape_cast: ShapeCast2D = $One_Way_Platform_ShapeCast
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var attack_area: Attack_Area = %Attack_Area
@onready var attack_sprite: Sprite2D = %Attack_Sprite
@onready var ha_stand: CollisionShape2D = %HA_Stand
@onready var ha_crouch: CollisionShape2D = %HA_Crouch
@onready var hurt_area: Hurt_Area = %Hurt_Area


signal damage_taken



#region 导出变量
# 奔跑速度
@export var run_speed: float = 200
# 最大下落速度
@export var max_fall_velocity: float = 600.0
#endregion


#region 状态机变量
# 状态数组
var states: Array[Player_State]
# 当前状态(获取状态数组的第一个状态)
var current_state: Player_State: 
	get: return states.front()
# 上一个状态(获取状态数组的第二个状态)
var previous_state: Player_State:
	get: return states[1]
#endregion



#region 玩家属性

var hp: float = 100:
	set(v):
		hp = clampf(v, 0, max_hp)
		Messages.player_hp_changed.emit(hp, max_hp)

var max_hp: float = 100:
	set(v):
		max_hp = clampf(v, 0, 500)
		Messages.player_hp_changed.emit(hp, max_hp)

# 是否能冲刺
var dash: bool = false
# 冲刺计数
var dash_count: int = 0
# 是否能二段跳
var double_jump: bool = true
# 跳跃计数
var jump_count: int = 0
# 是否能砸地攻击
var ground_slam: bool = false
# 是否能翻滚
var roll: bool = false

#endregion




#region 标准变量
# 玩家方向
var direction: Vector2 = Vector2.ZERO
# 重力值
var gravity: float = 980.0
# 重力倍数
var gravity_multiper: float = 1.0
#endregion




func _ready() -> void:
	
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	
	initialize_states()
	# 将自己移动到场景树的根节点
	self.call_deferred("reparent", get_tree().root)
	
	Messages.player_hp_changed.emit(hp, max_hp)
	Messages.player_healed.connect(_on_player_healed)
	Messages.back_title.connect(queue_free)
	
	hurt_area.damage_taken.connect(_on_damage_taken)
	
	hp = max_hp




func _process(_delta: float) -> void:
	update_direction()
	change_state(current_state.process(_delta))



func _physics_process(_delta: float) -> void:
	# 施加重力
	velocity.y += gravity * _delta * gravity_multiper
	# 限制下落速度
	velocity.y = clampf(velocity.y, -5000.0, max_fall_velocity)
	
	move_and_slide()
	
	change_state(current_state.physics_process(_delta))
	
	




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("jump") and velocity.y < 0:
		velocity.y *= 0.1
	# 用户按下不同按键时触发对应效果
	if event.is_action_pressed("interact, confirm"):
		Messages.player_interacted.emit(self)
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu: Pause_Menu = load("res://pause_menu/pause_menu.tscn").instantiate()
		add_child(pause_menu)
		return
	
	# 有按键输入时，随时监控并改变角色状态
	change_state(current_state.handle_input(event))
	
	
	#region 调试功能
	if OS.is_debug_build():
		
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_KP_1:
				hp -= 2
			elif event.keycode == KEY_KP_2:
				hp += 2
			elif event.keycode == KEY_KP_ADD:
				max_hp += 2
			elif event.keycode == KEY_KP_SUBTRACT:
				max_hp -= 2
	
	#endregion




# 所有状态初始化
func initialize_states():
	# 初始化清空状态数组
	states = []
	
	# 收集并连接所有状态
	for c in %States.get_children():
		if c is Player_State:
			states.append(c)
			c.player = self
	
	# 如果没有状态就直接结束
	if states.size() == 0: return
	
	# 执行所有状态中的初始化函数
	for state in states:
		state.init()
	
	# 改变当前状态为数组第一个状态(Idle)
	change_state(current_state)
	
	current_state.enter()
	$State_Label.text = current_state.name




# 改变当前状态
func change_state(new_state: Player_State):
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	# 如果有上一个状态,就调用其退出函数
	if current_state:
		current_state.exit()
	# 设置新状态为数组第一个
	states.push_front(new_state)
	# 调用当前状态的进入函数
	current_state.enter()
	# 仅保留状态数组前5个元素
	states.resize(5)
	
	$State_Label.text = current_state.name




# 更新方向
func update_direction():
	var pre_dir: Vector2 = direction
	
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	if pre_dir.x != direction.x:
		attack_area.flip(direction.x)
		if direction.x < 0:
			sprite.flip_h = true
			attack_sprite.flip_h = true
			attack_sprite.position.x = -24
		elif direction.x > 0:
			sprite.flip_h = false
			attack_sprite.flip_h = false
			attack_sprite.position.x = 24



# 治愈玩家
func _on_player_healed(amount: float):
	hp += amount


func reset_camera():
	camera_2d.reset_smoothing()



# 玩家受伤
func _on_damage_taken(_attack_area: Attack_Area):
	if current_state == Player_State_Death:
		return
	hp -= _attack_area.damage
	damage_taken.emit()
	print("玩家受伤：", hp)




func can_dash() -> bool:
	if dash == false or dash_count > 0:
		return false
	return true
