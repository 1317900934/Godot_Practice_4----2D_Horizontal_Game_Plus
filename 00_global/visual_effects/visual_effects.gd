extends Node


const DUST_EFFECT = preload("uid://cag78cwrukrxe")
const HIT_PARTICLES = preload("uid://dvouv875v73jb")

signal camera_shook(strength: float)




func _create_dust_effect(pos: Vector2) -> Dust_Effect:
	
	var dust: Dust_Effect = DUST_EFFECT.instantiate()
	add_child(dust)
	dust.global_position = pos
	
	return dust




func jump_dust(pos: Vector2):
	var dust: Dust_Effect = _create_dust_effect(pos)
	dust.start(dust.TYPE.JUMP)


func land_dust(pos: Vector2):
	var dust: Dust_Effect = _create_dust_effect(pos)
	dust.start(dust.TYPE.LAND)


func hit_dust(pos: Vector2):
	var dust: Dust_Effect = _create_dust_effect(pos)
	dust.start(dust.TYPE.HIT)




func hit_particles(pos: Vector2, dir: Vector2, settings: Hit_Particles_Settings):
	var p: Hit_Particles = HIT_PARTICLES.instantiate()
	add_child(p)
	p.global_position = pos
	p.start(dir, settings)





func camera_shake(strength: float = 1.0):
	camera_shook.emit(strength)
