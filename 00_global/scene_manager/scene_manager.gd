extends CanvasLayer


@onready var fade_anim: AnimationPlayer = $Fade/Fade_Anim


signal load_scene_started
signal new_scene_ready(target_name: String, offset: Vector2)
signal load_scene_finished
signal scene_entered(uid: String)



# 当前场景的uid
var current_scene_uid: String




func _ready() -> void:
	await get_tree().process_frame
	load_scene_finished.emit()
	var current_scene = get_tree().current_scene.scene_file_path
	current_scene_uid = ResourceUID.path_to_uid(current_scene)
	scene_entered.emit(current_scene_uid)



# 切换场景
func transition_scene(new_scene: String, target_area: String, player_offset: Vector2, _dir: String = ""):
	
	get_tree().paused = true
	
	fade_anim.play("fade_in" + _dir)
	await fade_anim.animation_finished
	
	load_scene_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(new_scene)
	
	# 保存场景uid并发射信号
	current_scene_uid = ResourceUID.path_to_uid(new_scene)
	scene_entered.emit(current_scene_uid)
	
	await get_tree().scene_changed
	new_scene_ready.emit(target_area, player_offset)
	
	get_tree().paused = false
	
	
	load_scene_finished.emit()
	
	
	
	fade_anim.play("fade_out" + _dir)
