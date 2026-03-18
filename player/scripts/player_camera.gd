class_name Player_Camera
extends Camera2D


var shake_strength: float = 0

@export var shake_decay_rate: float = 5.0
@export var max_shake_offset: float = 10.0



func _ready() -> void:
	VisualEffects.camera_shook.connect(_apply_shake)



func _process(delta: float) -> void:
	offset = Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)




func _apply_shake(strength: float):
	shake_strength = min(strength, max_shake_offset)
