class_name Player_State_Hurt
extends Player_State

@export var move_speed: float = 100.0
@export var invulnerable_duration: float = 0.5


var timer:  float = 0.0
var dir:  float = 1.0

@onready var hurt_area: Hurt_Area = %Hurt_Area
@onready var hurt_audio: AudioStreamPlayer2D = %Hurt_Audio


# 初始化
func init():
	hurt_area.damage_taken.connect(_on_damage_taken)



# 进入状态
func enter():
	player.anim_player.play("hurt")
	timer = player.anim_player.current_animation_length
	hurt_area.make_invulnerable(invulnerable_duration)
	hurt_audio.play()
	VisualEffects.camera_shake(2.0)


# 退出状态
func exit():
	pass


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	return null


# 状态进行
func process(_delta: float) -> Player_State:
	timer -= _delta
	if timer <= 0:
		if player.hp <= 0:
			return death
		return idle
	return null


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	player.velocity.x = move_speed * dir
	return null




func _on_damage_taken(attack_area: Attack_Area):
	if player.current_state == death: return
	player.change_state(self)
	if attack_area.global_position.x < player.global_position.x:
		dir = 1.0
	else:
		dir = -1.0
