class_name Player_State_Jump
extends Player_State


# 跳跃力
@export var jump_velocity: float = 480.0

@onready var jump_audio: AudioStreamPlayer2D = $"../../Audio/Jump_Audio"


# 初始化
func init():
	pass


# 进入状态
func enter():
	if player.is_on_floor():
		VisualEffects.jump_dust(player.global_position)
	else:
		VisualEffects.jump_dust(player.global_position)
	
	player.anim_player.play("jump")
	player.anim_player.pause()
	
	do_jump()
	
	# 如果上一个状态是下落,且当前没有按住跳跃键,就等待一个物理帧后中断跳跃
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.1
		player.change_state(fall)


# 退出状态
func exit():
	pass


# 用户输入处理
func handle_input(event: InputEvent) -> Player_State:
	if event.is_action_pressed("dash, cancel") and player.can_dash():
		return dash
	
	if event.is_action_pressed("attack"):
		return attack
	
	if event.is_action_released("jump"):
		return fall
	return next_state


# 状态进行
func process(_delta: float) -> Player_State:
	set_jump_frame()
	return next_state


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.run_speed
	
	return next_state




# 将跳跃和下落加速度的值映射到对应动画时间的帧
func set_jump_frame():
	var frame: float = remap(player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5)
	player.anim_player.seek(frame, true)



func do_jump():
	if player.jump_count > 0:
		if player.double_jump == false:
			return
		elif player.jump_count > 1:
			return
	
	player.jump_count += 1
	jump_audio.play()
	player.velocity.y = -jump_velocity
