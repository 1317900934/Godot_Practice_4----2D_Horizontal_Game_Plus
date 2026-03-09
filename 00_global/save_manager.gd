extends Node


const CONFIG_FILE_PATH = "user://settings.cfg"

const SLOTS: Array[String] = [
	"save_01", "save_02", "save_03", "save_04", "save_05",
]


var save_data: Dictionary



# 存档文件槽位
var current_slot: int = 0
# 已发现的地图区域
var discovered_areas: Array = []
# 持久数据
var persistant_data: Dictionary = {}



func _ready() -> void:
	SceneManager.scene_entered.connect(_on_scene_entered)
	load_configuration()





func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F5:
			save_game()
		if event.keycode == KEY_F6:
			load_game(current_slot)
		if event.keycode == KEY_F1:
			current_slot = 0
			print("切换到存档槽1")
		if event.keycode == KEY_F2:
			current_slot = 1
			print("切换到存档槽2")
		if event.keycode == KEY_F3:
			current_slot = 2
			print("切换到存档槽3")
		if event.keycode == KEY_F4:
			current_slot = 4
			print("切换到存档槽5")
	




# 创建新游戏存档并载入
func create_new_game_save(slot: int):
	# 切换当前槽位
	current_slot = slot
	
	# 清除当前存档的旧数据
	discovered_areas.clear()
	persistant_data.clear()
	
	# 设置初始场景
	var new_game_scene: String = "uid://bamv77nyd2wge"
	# 将初始场景插入到当前存档的已发现区域数据
	discovered_areas.append(new_game_scene)
	
	
	# 初始化存档数据
	save_data = {
		"scene_path": new_game_scene,
		"player_x": -118.0,
		"player_y": 324.0,
		"player_hp": 20,
		"player_max_hp": 20,
		"dash": false,
		"double_jump": false,
		"ground_slam": false,
		"roll": false,
		"discovered_areas": discovered_areas,
		"persistant_data": persistant_data,
	}
	# 准备写入存档文件
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	# 将存档数据存储为JSON文本
	save_file.store_line(JSON.stringify(save_data))
	
	# 结束读写操作后载入存档
	save_file.close()
	load_game(slot)






func save_game():
	var player: Player = get_tree().get_first_node_in_group("Player")
	save_data = {
		"scene_path": SceneManager.current_scene_uid,
		"player_x": player.global_position.x,
		"player_y": player.global_position.y,
		"player_hp": player.hp,
		"player_max_hp": player.max_hp,
		"dash": player.dash,
		"double_jump": player.double_jump,
		"ground_slam": player.ground_slam,
		"roll": player.roll,
		"discovered_areas": discovered_areas,
		"persistant_data": persistant_data,
	}
	# 准备写入存档文件
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	# 将存档数据存储为JSON文本
	save_file.store_line(JSON.stringify(save_data))
	print("【保存游戏】" + get_file_name(current_slot))





func load_game(slot: int):
	# 没有对应存档时直接返回
	if not FileAccess.file_exists(get_file_name(current_slot)): return
	
	current_slot = slot
	
	# 获取存档文件中第一行的所有存档数据
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line())
	
	# 从存档数据中加载持久数据和已发现区域(如果存档中没有对应键值则返回空)
	persistant_data = save_data.get("persistant_data", {})
	discovered_areas = save_data.get("discovered_areas", [])
	# 从存档数据中加载并切换场景
	var scene_path: String = save_data.get("scene_path", "uid://bamv77nyd2wge")
	SceneManager.transition_scene(scene_path, "", Vector2.ZERO)
	
	await SceneManager.new_scene_ready
	setup_player()
	
	
	print("【加载游戏】" + get_file_name(current_slot))





# 加载当前存档中的玩家数据
func setup_player():
	var player: Player = null
	
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.max_hp = save_data.get("player_max_hp", 20)
	player.hp = save_data.get("player_hp", 20)
	
	player.dash = save_data.get("dash", false)
	player.double_jump = save_data.get("double_jump", false)
	player.ground_slam = save_data.get("ground_slam", false)
	player.roll = save_data.get("roll", false)
	
	player.global_position = Vector2(
		save_data.get("player_x", 0),
		save_data.get("player_y", 0)
	)
	
	print (save_data.get("player_x", 0),
		save_data.get("player_y", 0))



# 获取存档文件名称
func get_file_name(slot) -> String:
	
	return "user://" + SLOTS[slot] + ".sav"



# 检测对应存档文件是否存在
func save_file_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))



# 查询某场景当前是否已发现
func is_area_discovered(scene_uid: String) -> bool:
	return discovered_areas.has(scene_uid)



# 场景进入
func _on_scene_entered(scene_uid: String):
	if discovered_areas.has(scene_uid):
		return
	else:
		discovered_areas.append(scene_uid)




#region 配置设置
func save_configuration():
	var config:= ConfigFile.new()
	config.set_value("audio", "music", AudioServer.get_bus_volume_linear(2))
	config.set_value("audio", "sfx", AudioServer.get_bus_volume_linear(3))
	config.set_value("audio", "ui", AudioServer.get_bus_volume_linear(4))
	config.save(CONFIG_FILE_PATH)



func load_configuration():
	var config:= ConfigFile.new()
	var err = config.load(CONFIG_FILE_PATH)
	
	if err != OK:
		AudioServer.set_bus_volume_linear(2, 0.5)
		AudioServer.set_bus_volume_linear(3, 0.5)
		AudioServer.set_bus_volume_linear(4, 0.5)
		save_configuration()
	
	AudioServer.set_bus_volume_linear(2, config.get_value("audio", "music", 0.5))
	AudioServer.set_bus_volume_linear(3, config.get_value("audio", "sfx", 0.5))
	AudioServer.set_bus_volume_linear(4, config.get_value("audio", "ui", 0.5))
	
#endregion
