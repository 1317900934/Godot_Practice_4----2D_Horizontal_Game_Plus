class_name Player
extends CharacterBody2D


@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var sprite: Sprite2D = $Sprite2D
@onready var one_way_platform_shape_cast: ShapeCast2D = $One_Way_Platform_ShapeCast
@onready var anim_player: AnimationPlayer = $AnimationPlayer



#region 导出变量
# 奔跑速度
@export var run_speed: float = 200
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


#region 标准变量
# 玩家方向
var direction: Vector2 = Vector2.ZERO
# 重力值
var gravity: float = 980.0
# 重力倍数
var gravity_multiper: float = 1.0
#endregion




func _ready() -> void:
	initialize_states()




func _process(_delta: float) -> void:
	update_direction()
	change_state(current_state.process(_delta))



func _physics_process(_delta: float) -> void:
	# 施加重力
	velocity.y += gravity * _delta * gravity_multiper
	move_and_slide()
	
	change_state(current_state.physics_process(_delta))
	
	




func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))




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
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
