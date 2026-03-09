class_name Pause_Menu
extends CanvasLayer

#region onready变量
@onready var pause_screen: Control = $Pause_Screen
@onready var system: Control = $System
@onready var system_menu_button: Button = %System_Menu_Button
@onready var close_button: Button = %Close_Button


@onready var music_slider: HSlider = %Music_Slider
@onready var sfx_slider: HSlider = %SFX_Slider
@onready var ui_slider: HSlider = %UI_Slider
@onready var back_to_map: Button = %Back_to_Map
@onready var back_to_title: Button = %Back_to_Title
#endregion


var player_pos: Vector2



func _ready() -> void:
	show_pause_screen()
	system_menu_button.pressed.connect(show_system_menu)
	Audio.setup_button_audio(self)
	setup_system_menu()
	var player: Node2D = get_tree().get_first_node_in_group("Player")
	if player:
		player_pos = player.global_position



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	




# 显示暂停菜单
func show_pause_screen():
	pause_screen.visible = true
	system.visible = false
	close_button.grab_focus()


# 显示系统菜单
func show_system_menu():
	pause_screen.visible = false
	system.visible = true
	back_to_map.grab_focus()



# 配置选项菜单
func setup_system_menu():
	music_slider.value = AudioServer.get_bus_volume_linear(2)
	sfx_slider.value = AudioServer.get_bus_volume_linear(3)
	ui_slider.value = AudioServer.get_bus_volume_linear(4)
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	ui_slider.value_changed.connect(_on_ui_slider_changed)
	
	back_to_title.pressed.connect(_on_back_to_title_pressed)
	back_to_map.pressed.connect(show_pause_screen)



func _on_back_to_title_pressed():
	get_tree().paused = false
	SceneManager.transition_scene("res://title_screen/title_screen.tscn", "", Vector2.ZERO, "")
	await SceneManager.load_scene_started
	Messages.back_title.emit()
	queue_free()



func _on_close_button_pressed() -> void:
	get_tree().paused = false
	queue_free()




func _on_music_slider_changed(v: float):
	AudioServer.set_bus_volume_linear(2, v)
	SaveManager.save_configuration()

func _on_sfx_slider_changed(v: float):
	AudioServer.set_bus_volume_linear(3, v)
	Audio.play_spatial_sound(Audio.ui_press_audio, player_pos)
	SaveManager.save_configuration()

func _on_ui_slider_changed(v: float):
	AudioServer.set_bus_volume_linear(4, v)
	Audio.ui_focus_change()
	SaveManager.save_configuration()
