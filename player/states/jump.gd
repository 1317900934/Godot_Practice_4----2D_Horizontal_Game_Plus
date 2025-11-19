class_name Player_State_Jump
extends Player_State


# 跳跃力
@export var jump_velocity: float = 480.0



# 初始化
func init():
	pass


# 进入状态
func enter():
	player.anim_player.play("jump")
	player.velocity.y = -jump_velocity


# 退出状态
func exit():
	pass


# 用户输入处理
func handle_input(event: InputEvent) -> Player_State:
	if event.is_action_released("jump"):
		player.velocity.y *= 0.1
		return fall
	return next_state


# 状态进行
func process(_delta: float) -> Player_State:
	
	return next_state


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.run_speed
	
	return next_state
