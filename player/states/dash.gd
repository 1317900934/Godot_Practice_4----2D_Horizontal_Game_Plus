class_name Player_State_Dash
extends Player_State

const DASH_AUDIO = preload("uid://c1deufsloexlv")

@export var duration: float = 0.20
@export var speed: float = 500.0
@export var effect_delay: float = 0.05


var dir: float = 1.0
var time: float = 0.0
var effect_time: float = 0.0

@onready var hurt_area: Hurt_Area = %Hurt_Area


# 初始化
func init():
	pass


# 进入状态
func enter():
	player.anim_player.play("dash")
	time = duration
	effect_time = 0.0
	get_dash_dir()
	hurt_area.make_invulnerable(duration)
	Audio.play_spatial_sound(DASH_AUDIO, player.global_position)
	
	player.gravity_multiper = 0.0
	player.velocity.y = 0.0
	
	player.dash_count += 1
	
	player.sprite._tween_color(duration)
	



# 退出状态
func exit():
	player.gravity_multiper = 1.0


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	return null


# 状态进行
func process(_delta: float) -> Player_State:
	time -= _delta
	if time <= 0:
		if player.is_on_floor():
			return idle
		else:
			return fall
	
	effect_time -= _delta
	if effect_time < 0:
		effect_time = effect_delay
		player.sprite.ghost()
	return null


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	player.velocity.x = (speed * (time / duration) + speed) * dir
	return null



func get_dash_dir():
	dir = 1.0
	if player.sprite.flip_h == true:
		dir = -1.0
