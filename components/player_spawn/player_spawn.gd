@icon("res://components/icons/player_spawn.svg")
class_name Player_Spawn
extends Node2D


func _ready() -> void:
	visible = false
	
	await get_tree().process_frame
	
	if get_tree().get_first_node_in_group("Player"):
		print("当前已有玩家")
		return
	
	
	var player: Player = load("uid://tkgp05hf7nga").instantiate()
	get_tree().root.add_child(player)
	player.global_position = self.global_position
	
	print("生成玩家成功")
