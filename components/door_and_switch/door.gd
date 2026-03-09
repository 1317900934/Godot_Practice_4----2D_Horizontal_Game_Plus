@tool
@icon("res://components/icons/door.svg")
class_name Door
extends Node2D


const DOOR_OPEN_AUDIO = preload("uid://wsufd08gci3l")


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	for c in get_children():
		if c is Switch:
			c.activated.connect(_on_switch_activated)
			if c.is_open == true:
				_on_switch_open()




func _on_switch_activated():
	Audio.play_spatial_sound(DOOR_OPEN_AUDIO, global_position)
	animation_player.play("open")




func _on_switch_open():
	animation_player.play("opened")





# 若没有开关就发出警告
func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_switch() == false:
		return ["需要一个开关节点"]
	return []




# 检查子节点是否有开关
func _check_for_switch() -> bool:
	
	for c in get_children():
		if c is Switch:
			return true
	
	return false
