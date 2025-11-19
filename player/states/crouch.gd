class_name Player_State_Crouch
extends Player_State


# 移动时蹲下的减速率
@export var deceleration_rate: float = 20.0



# 初始化
func init():
	pass


# 进入状态
func enter():
	player.anim_player.play("crouch")
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false


# 退出状态
func exit():
	player.collision_crouch.disabled = true
	player.collision_stand.disabled = false
	player.sprite.frame = 0



# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	if _event.is_action_released("crouch"):
		return idle
	elif _event.is_action_pressed("jump"):
		player.one_way_platform_shape_cast.force_shapecast_update()
		if player.one_way_platform_shape_cast.is_colliding() == true:
			player.position.y += 5
			return fall
		
		return jump
	
	return next_state


# 状态进行
func process(_delta: float) -> Player_State:
	
	
	return next_state


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	player.velocity.x -= player.velocity.x * deceleration_rate * _delta
	if player.is_on_floor() == false:
		return fall
	return next_state
