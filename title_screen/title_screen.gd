extends CanvasLayer

#region onready变量
@onready var main_menu: Control = $Control/Main_Menu
@onready var load_menu: Control = $Control/Load_Menu
@onready var new_start_menu: Control = $Control/New_Start_Menu


@onready var new_game: Button = %New_Game
@onready var load_game: Button = %Load_Game

@onready var start_new_1: Button = %Start_New_1
@onready var start_new_2: Button = %Start_New_2
@onready var start_new_3: Button = %Start_New_3
@onready var start_new_4: Button = %Start_New_4
@onready var start_new_5: Button = %Start_New_5
@onready var new_start_menu_return: Button = %New_Start_Menu_Return
@onready var new_game_scroll_container: ScrollContainer = %New_Game_ScrollContainer


@onready var load_slot_1: Button = %Load_Slot_1
@onready var load_slot_2: Button = %Load_Slot_2
@onready var load_slot_3: Button = %Load_Slot_3
@onready var load_slot_4: Button = %Load_Slot_4
@onready var load_slot_5: Button = %Load_Slot_5
@onready var load_menu_return: Button = %Load_Menu_Return
@onready var load_game_scroll_container: ScrollContainer = %Load_Game_ScrollContainer

#endregion


func _ready() -> void:
	new_game.pressed.connect(show_new_start_menu)
	load_game.pressed.connect(show_load_menu)
	
	new_start_menu_return.pressed.connect(show_main_menu)
	load_menu_return.pressed.connect(show_main_menu)
	
	start_new_1.pressed.connect(_on_new_game_pressed.bind(0))
	start_new_2.pressed.connect(_on_new_game_pressed.bind(1))
	start_new_3.pressed.connect(_on_new_game_pressed.bind(2))
	start_new_4.pressed.connect(_on_new_game_pressed.bind(3))
	start_new_5.pressed.connect(_on_new_game_pressed.bind(4))
	
	load_slot_1.pressed.connect(_on_load_pressed.bind(0))
	load_slot_2.pressed.connect(_on_load_pressed.bind(1))
	load_slot_3.pressed.connect(_on_load_pressed.bind(2))
	load_slot_4.pressed.connect(_on_load_pressed.bind(3))
	load_slot_5.pressed.connect(_on_load_pressed.bind(4))
	
	# 为所有按钮设置音频
	Audio.setup_button_audio(self)
	
	show_main_menu()



# 显示主菜单
func show_main_menu():
	main_menu.visible = true
	new_start_menu.visible = false
	load_menu.visible = false
	new_game.grab_focus()


# 显示新游戏菜单
func show_new_start_menu():
	main_menu.visible = false
	new_start_menu.visible = true
	load_menu.visible = false
	start_new_1.grab_focus()
	new_game_scroll_container.scroll_vertical = 0
	
	if SaveManager.save_file_exists(0):
		start_new_1.text = "覆盖记忆01"
	if SaveManager.save_file_exists(1):
		start_new_2.text = "覆盖记忆02"
	if SaveManager.save_file_exists(2):
		start_new_3.text = "覆盖记忆03"
	if SaveManager.save_file_exists(3):
		start_new_4.text = "覆盖记忆04"
	if SaveManager.save_file_exists(4):
		start_new_5.text = "覆盖记忆05"


# 显示加载游戏菜单
func show_load_menu():
	main_menu.visible = false
	new_start_menu.visible = false
	load_menu.visible = true
	load_slot_1.grab_focus()
	load_game_scroll_container.scroll_vertical = 0
	
	load_slot_1.disabled = not SaveManager.save_file_exists(0)
	load_slot_2.disabled = not SaveManager.save_file_exists(1)
	load_slot_3.disabled = not SaveManager.save_file_exists(2)
	load_slot_4.disabled = not SaveManager.save_file_exists(3)
	load_slot_5.disabled = not SaveManager.save_file_exists(4)



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if main_menu.visible == false:
			show_main_menu()



# 新存档槽位被按下
func _on_new_game_pressed(slot: int):
	SaveManager.create_new_game_save(slot)
	



# 加载存档槽位被按下
func _on_load_pressed(slot: int):
	SaveManager.load_game(slot)


# 退出游戏
func _on_quit_game_pressed() -> void:
	get_tree().quit()
