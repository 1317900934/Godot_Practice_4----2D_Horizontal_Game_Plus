extends CanvasLayer

@onready var hp_margin_container: MarginContainer = $HUD/HP_MarginContainer
@onready var hp_bar: TextureProgressBar = $HUD/HP_MarginContainer/NinePatchRect/HP_Bar



@onready var game_over: Control = %Game_Over
@onready var load_button: Button = %Load_Button
@onready var quit_button: Button = %Quit_Button






func _ready() -> void:
	Messages.player_hp_changed.connect(update_hp_bar)
	game_over.visible = false
	load_button.pressed.connect(_on_load_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)



func update_hp_bar(hp: float, max_hp: float):
	var value: float = (hp / max_hp) * 100
	hp_bar.value = value
	hp_margin_container.size.x = (max_hp / 3) + 60.0




# 显示游戏结束界面
func show_game_over():
	load_button.visible = false
	quit_button.visible = false
	
	game_over.modulate.a = 0
	game_over.visible = true
	
	var tween: Tween = create_tween()
	tween.tween_property(game_over, "modulate", Color.WHITE, 1.0)
	await tween.finished
	
	load_button.visible = true
	quit_button.visible = true
	load_button.grab_focus()




func clear_game_over():
	load_button.visible = false
	quit_button.visible = false
	await SceneManager.load_scene_started
	game_over.visible = false
	
	var player: Player = get_tree().get_first_node_in_group("Player")
	
	player.queue_free()





func _on_load_button_pressed():
	SaveManager.load_game(SaveManager.current_slot)
	clear_game_over()



func _on_quit_button_pressed():
	SceneManager.transition_scene("res://title_screen/title_screen.tscn", "", Vector2.ZERO)
	clear_game_over()
