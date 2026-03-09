@tool
@icon("res://components/icons/level_bounds.svg")
extends Node2D
class_name Level_Bounds

@export_range(480, 16384, 32, "suffix:px") var width: int = 480: set = _on_witdth_changed
@export_range(270, 16384, 32, "suffix:px") var height: int = 270: set = _on_height_changed


func _ready() -> void:
	z_index = 256
	
	if Engine.is_editor_hint(): return
	
	var camera: Camera2D = null
	
	while not camera:
		await get_tree().process_frame
		camera = get_viewport().get_camera_2d()
	
	
	print("已获取视窗相机")
	camera.limit_left = int(global_position.x)
	camera.limit_top = int(global_position.y)
	camera.limit_right = int(global_position.x) + width
	camera.limit_bottom = int(global_position.y) + height
	print("已设置视窗移动范围")
	



func  _draw() -> void:
	if Engine.is_editor_hint():
		var r: Rect2 = Rect2(Vector2.ZERO, Vector2(width, height))
		draw_rect(r, Color(0.306, 0.537, 0.878, 0.5), false, 3)
		draw_rect(r, Color(0.079, 0.72, 0.88, 1.0), false, 1)




func _on_witdth_changed(new_width: int):
	width = new_width
	queue_redraw()

func _on_height_changed(new_height: int):
	height = new_height
	queue_redraw()
