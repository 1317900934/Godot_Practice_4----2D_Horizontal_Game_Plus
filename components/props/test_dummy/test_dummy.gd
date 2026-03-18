extends Node2D



@export var particles: Array[Hit_Particles_Settings]
@export var base_wobble_angle: float = 4.0
@export var wobble_speed: float = 0.1

# 摇摆次数
var wobble_count: int = 0

var tween: Tween

@onready var body_sprite: Sprite2D = $Body_Sprite
@onready var hurt_area: Hurt_Area = $Hurt_Area


func _on_damage_taken(attack_area: Attack_Area) -> void:
	var dir: float = 1.0
	if attack_area.global_position.x > global_position.x:
		dir = -1.0
	
	var pos: Vector2 = global_position + Vector2(0, -30)
	
	for p in particles:
		VisualEffects.hit_particles(pos, Vector2(dir, 0), p)
	
	wobble_count = 5
	wobble(dir)




func wobble(dir):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(
		body_sprite,
		"rotation_degrees",
		base_wobble_angle * wobble_count * dir,
		wobble_speed * 0.5
		)
	
	while wobble_count > 0:
		dir *= -1
		wobble_count -= 1
		tween.tween_property(
			body_sprite,
			"rotation_degrees",
			base_wobble_angle * wobble_count * dir,
			wobble_speed
		)
