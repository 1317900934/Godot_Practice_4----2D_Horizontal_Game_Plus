class_name Player_State_Run
extends Player_State






# 初始化
func init():
	pass


# 进入状态
func enter():
	player.anim_player.play("run")


# 退出状态
func exit():
	pass


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	if _event.is_action_pressed("jump"):
		return jump
	elif _event.is_action_pressed("crouch"):
		return crouch
	
	return next_state


# 状态进行
func process(_delta: float) -> Player_State:
	if player.direction.x == 0:
		return idle
	elif player.direction.y >= 0.5:
		pass
	
	return next_state


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	player.velocity.x = player.direction.x * player.run_speed
	if player.is_on_floor() == false:
		return fall
	return next_state
