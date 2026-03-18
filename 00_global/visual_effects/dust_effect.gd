class_name Dust_Effect
extends Sprite2D


enum TYPE{JUMP, LAND, HIT}

@onready var anim_player: AnimationPlayer = $AnimationPlayer





func start(type: TYPE):
	var anim_name: String = "jump"
	
	match type:
		TYPE.JUMP:
			position.y -= 14
			anim_name = "jump"
		
		TYPE.LAND:
			position.y -= 14
			anim_name = "land"
		
		TYPE.HIT:
			anim_name = "hit"
			rotation_degrees = randi_range(0, 3) * 90
	
	anim_player.play(anim_name)
	await anim_player.animation_finished
	
	queue_free()
