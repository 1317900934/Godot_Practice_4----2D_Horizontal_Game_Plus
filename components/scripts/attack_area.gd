@icon("res://components/icons/attack_area.svg")
class_name Attack_Area
extends Area2D


@export var damage: float = 1.0




func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	monitorable = false
	monitoring = false
	visible = false


func _on_body_entered(body: Node2D) -> void:
	
	if body is Hurt_Area:
		body.take_hurt(self)
		var pos: Vector2 = global_position
		pos.x = body.global_position.x
		VisualEffects.hit_dust(pos)



func activate(duration: float = 0.1):
	set_active()
	await get_tree().create_timer(duration).timeout
	set_active(false)



func set_active(value: bool = true):
	monitoring = value
	visible = value



func flip(dir_x: float):
	if dir_x > 0:
		scale.x = 1
	elif dir_x < 0:
		scale.x = -1
