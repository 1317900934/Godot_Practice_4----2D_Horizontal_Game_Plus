class_name Player_State_Attack
extends Player_State

const AUDIO_ATTACK = preload("uid://1c1y5ia1wy2w")


@export var combo_time_window: float = 0.2
@export var move_speed: float = 200.0

@onready var attack_sprite: Sprite2D = %Attack_Sprite

var timer: float = 0
var combo: int = 0




# 初始化
func init():
	attack_sprite.visible = false


# 进入状态
func enter():
	do_attack()
	player.anim_player.animation_finished.connect(_on_animation_finished)



# 退出状态
func exit():
	timer = 0
	combo = 0
	attack_sprite.visible = false
	next_state = null
	player.anim_player.animation_finished.disconnect(_on_animation_finished)
	attack_sprite.visible = false


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	if _event.is_action_pressed("attack"):
		timer = combo_time_window
	if _event.is_action_pressed("dash, cancel") and player.can_dash():
		return dash
	
	return null


# 状态进行
func process(_delta: float) -> Player_State:
	timer -= _delta
	return next_state


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	player.velocity.x = player.direction.x * move_speed
	return null



func do_attack():
	var anim_name: String = "attack"
	if combo > 0:
		anim_name = "attack_2"
	player.anim_player.play(anim_name)
	player.attack_area.activate()
	Audio.play_spatial_sound(AUDIO_ATTACK, player.global_position)



func _on_animation_finished(_anim_name: String):
	_end_attack()
	
	



func _end_attack():
	if timer > 0:
		combo = wrapi(combo + 1, 0, 2)
		do_attack()
	else:
		if player.is_on_floor():
			next_state = idle
		else:
			next_state = fall
