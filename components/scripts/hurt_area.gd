@icon("res://components/icons/damage_area.svg")
class_name Hurt_Area
extends Area2D



signal damage_taken(attack_area)



@export var audio: AudioStream



func take_hurt(attack_area: Attack_Area):
	damage_taken.emit(attack_area)
	if audio:
		Audio.play_spatial_sound(audio, global_position)



func make_invulnerable(duration: float = 0.1):
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
