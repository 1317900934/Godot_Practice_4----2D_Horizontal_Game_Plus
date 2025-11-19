class_name Player_State_Fall
extends Player_State

@export var fall_gravity_multiper: float = 1.2
@export var coyote_time: float = 0.1
# 在空中落下时预先记录某些输入指令的时间
@export var buffer_time: float = 0.2



# 踩空后仍可跳跃计时器
var coyote_timer: float = 0
# 落地前预先跳跃计时器
var jump_buffer_timer: float = 0
# 落地前预先蹲下计时器
var crouch_buffer_timer: float = 0


# 初始化
func init():
	pass


# 进入状态
func enter():
	player.gravity_multiper = fall_gravity_multiper
	if player.previous_state == jump:
		coyote_timer = 0
	else:
		coyote_timer = coyote_time


# 退出状态
func exit():
	player.gravity_multiper = 1.0


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0:
			return jump
		else:
			jump_buffer_timer = buffer_time
	elif _event.is_action_pressed("crouch"):
			crouch_buffer_timer = buffer_time
	
	return next_state


# 状态进行
func process(_delta: float) -> Player_State:
	coyote_timer -= _delta
	jump_buffer_timer -= _delta
	crouch_buffer_timer -= _delta
	return next_state


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	if player.is_on_floor():
		if jump_buffer_timer > 0:
			return jump
		elif crouch_buffer_timer > 0:
			return crouch
		return idle
	
	player.velocity.x = player.direction.x * player.run_speed
	return next_state
