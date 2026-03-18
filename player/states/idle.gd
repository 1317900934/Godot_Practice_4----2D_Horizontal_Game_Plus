class_name Player_State_Idle
extends Player_State




# 初始化
func init():
	pass


# 进入状态
func enter():
	player.anim_player.play("idle")
	player.jump_count = 0
	player.dash_count = 0


# 退出状态
func exit():
	pass


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	
	if _event.is_action_pressed("dash, cancel") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("jump"):
		return jump
	if _event.is_action_pressed("crouch"):
		return crouch
	
	return null


# 状态进行
func process(_delta: float) -> Player_State:
	if player.direction.x != 0:
		return run
	elif player.direction.y >= 0.5:
		pass
	
	return null


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state
