class_name Player_State_Fall
extends Player_State

# 下落重力倍数
@export var fall_gravity_multiper: float = 1.15
# 突然滞空的可跳跃时间
@export var coyote_time: float = 0.1
# 在空中落下时预先记录某些输入指令的时间
@export var buffer_time: float = 0.2



# 踩空后仍可跳跃计时器
var coyote_timer: float = 0
# 落地前预先跳跃计时器
var jump_buffer_timer: float = 0

@onready var land_audio: AudioStreamPlayer2D = $"../../Audio/Land_Audio"


# 初始化
func init():
	pass


# 进入状态
func enter():
	player.anim_player.play("jump")
	player.anim_player.pause()
	
	player.gravity_multiper = fall_gravity_multiper
	
	if player.jump_count == 0:
		player.jump_count = 1
	
	var prev: Player_State = player.previous_state
	if prev == jump or prev == attack or prev == dash:
		coyote_timer = 0
	elif player.previous_state == crouch:
		coyote_timer = 0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time


# 退出状态
func exit():
	player.gravity_multiper = 1.0
	jump_buffer_timer = 0


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	
	if _event.is_action_pressed("dash, cancel") and player.can_dash():
		return dash
	
	if _event.is_action_pressed("attack"):
		return attack
	
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0:
			player.jump_count = 0
			return jump
		elif player.jump_count <= 1 and player.double_jump:
			return jump
		else:
			jump_buffer_timer = buffer_time
	
	return next_state







# 状态进行
func process(_delta: float) -> Player_State:
	coyote_timer -= _delta
	jump_buffer_timer -= _delta
	set_jump_frame()
	return next_state







# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	if player.is_on_floor():
		
		land_audio.play()
		VisualEffects.land_dust(player.global_position)
		
		#if jump_buffer_timer > 0 and Input.is_action_pressed("jump"):
		if jump_buffer_timer > 0:
			player.jump_count = 0
			return jump
		if Input.is_action_pressed("crouch"):
			return crouch
		return idle
	
	player.velocity.x = player.direction.x * player.run_speed
	return next_state




func set_jump_frame():
	var frame: float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.anim_player.seek(frame, true)
	pass
