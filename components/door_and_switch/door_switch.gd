@icon("res://components/icons/switch.svg")
class_name Switch
extends Node2D



signal activated

const DOOR_SWITCH_AUDIO = preload("uid://daiijpsanbbqq")


var is_open: bool = false


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var outline_anim: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $Sprite2D/GPUParticles2D
@onready var point_light_2d: PointLight2D = $Sprite2D/PointLight2D



func _ready() -> void:
	# 检查存档对应键值是否是开启，如果没有对应键值就添加并获取一个默认值
	if SaveManager.persistant_data.get_or_add(unique_name(), "closed") == "open":
		set_open()
	else:
		area_2d.body_entered.connect(_on_player_entered)
		area_2d.body_exited.connect(_on_player_exited)





func _on_player_entered(_n: Node2D):
	Messages.input_hint_changed.emit("interact")
	Messages.player_interacted.connect(_on_player_interacted)
	outline_anim.play("outline_fade_in")




func _on_player_exited(_n: Node2D):
	Messages.input_hint_changed.emit("none")
	Messages.player_interacted.disconnect(_on_player_interacted)
	outline_anim.play("outline_fade_out")




# 玩家交互
func _on_player_interacted(_player: Player):
	Audio.play_spatial_sound(DOOR_SWITCH_AUDIO, global_position)
	SaveManager.persistant_data[unique_name()] = "open"
	activated.emit()
	gpu_particles_2d.emitting = true
	set_open()



# 设置门已开启时开关的状态
func set_open():
	is_open = true
	sprite_2d.frame = 1
	point_light_2d.enabled = true
	area_2d.queue_free()



# 获取自己的唯一名称
func unique_name() -> String:
	var u_name: String = ResourceUID.path_to_uid(owner.scene_file_path)
	u_name += "/" + get_parent().name + "/" + name
	return u_name
