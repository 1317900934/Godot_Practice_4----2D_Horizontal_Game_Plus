@icon("res://components/icons/save_point.svg")
class_name Save_Point
extends Node2D


@onready var outline_control: AnimationPlayer = $Sprite/Outline_Control
@onready var saved_anim: AnimationPlayer = $Saved_Tips/Saved_Anim





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Messages.player_interacted.connect(_on_player_interacted)
		Messages.input_hint_changed.emit("interact")
		outline_control.play("fade_in")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		Messages.player_interacted.disconnect(_on_player_interacted)
		outline_control.play("fade_out")
		Messages.input_hint_changed.emit("none")



func _on_player_interacted(_player: Player):
	
	# 发射治愈玩家信号治愈玩家
	Messages.player_healed.emit(9999)
	
	# 保存游戏
	SaveManager.save_game()
	
	# 播放保存完毕的音效和动画
	Audio.play_ui_audio(preload("uid://bg0l5qhenqj7x"))
	saved_anim.play("saved")
	saved_anim.seek(0)
