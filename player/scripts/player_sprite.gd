class_name Player_Sprite
extends Sprite2D


var tween: Tween




func _tween_color(duration: float = 0.5, color: Color = Color.SKY_BLUE):
	if tween:
		tween.kill()
	modulate = color
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, duration)
	


func ghost():
	var effect: Node2D = Node2D.new()
	var p: Node2D = get_parent()
	p.add_sibling(effect)
	effect.get_parent().move_child(effect, 0)
	effect.z_index = 1
	effect.global_position = p.global_position
	effect.modulate = Color(0.035, 0.537, 0.69, 0.784)
	
	var sprite_copy: Sprite2D = duplicate()
	effect.add_child(sprite_copy)
	
	var t: Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(effect, "modulate", Color(0.5, 0.5, 0.5, 0), 0.2)
	t.chain().tween_callback(effect.queue_free)
	
