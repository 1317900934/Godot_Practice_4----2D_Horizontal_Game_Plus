class_name Player_State_Death
extends Player_State


const DEATH_AUDIO = preload("uid://22c5g4qn8ks0")

@onready var hurt_area: Hurt_Area = %Hurt_Area


# 进入状态
func enter():
	hurt_area.monitorable = false
	player.anim_player.play("death")
	Audio.play_spatial_sound(DEATH_AUDIO, player.global_position)
	Audio.play_bgm(null)
	await player.anim_player.animation_finished
	PlayerHud.show_game_over()



# 退出状态
func exit():
	pass


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	return null


# 状态进行
func process(_delta: float) -> Player_State:
	return null


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	player.velocity.x = 0
	return null
