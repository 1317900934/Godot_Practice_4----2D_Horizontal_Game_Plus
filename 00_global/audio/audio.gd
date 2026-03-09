extends Node


# 混响类型
enum REVERB_TYPE{NONE, SMALL, MEDIUM, LARGE}


@export var ui_focus_audio: AudioStream
@export var ui_press_audio: AudioStream
@export var ui_cancel_audio: AudioStream
@export var ui_success_audio: AudioStream
@export var ui_error_audio: AudioStream


# 当前音轨
var current_track: int = 0
# 所有补间动画
var music_tweens: Array[Tween]
# UI音效播放器
var ui_audio_player: AudioStreamPlaybackPolyphonic

@onready var bgm_player_1: AudioStreamPlayer = %BGM_Player_1
@onready var bgm_player_2: AudioStreamPlayer = %BGM_Player_2
@onready var ui_player: AudioStreamPlayer = %UI_Player





func _ready() -> void:
	# 使UI播放器启动复音流，并获取复音流实例
	ui_player.play()
	ui_audio_player = ui_player.get_stream_playback()
	





# 播放给定的UI音效
func play_ui_audio(audio: AudioStream):
	if ui_audio_player:
		ui_audio_player.play_stream(audio)


#region 播放UI音效
# 播放UI聚焦音效
func ui_focus_change():
	play_ui_audio(ui_focus_audio)

# 播放UI按下音效
func ui_press():
	play_ui_audio(ui_press_audio)

# 播放UI成功音效
func ui_success():
	play_ui_audio(ui_success_audio)

# 播放UI错误音效
func ui_error():
	play_ui_audio(ui_error_audio)

# 播放UI取消音效
func ui_cancel():
	play_ui_audio(ui_cancel_audio)
#endregion






# 给某节点的所有按钮设置音效
func setup_button_audio(node: Node):
	# 遍历节点的所有子孙节点，给所有Button类连接音效播放函数
	for c in node.find_children("*", "Button"):
		c.pressed.connect(ui_press)
		c.focus_entered.connect(ui_focus_change)







# 播放给定的背景音乐，并可在两条音轨间自然过渡
func play_bgm(audio: AudioStream):
	# 获得当前播放器
	var current_player: AudioStreamPlayer = get_music_player(current_track)
	# 如果给定的音乐和当前播放器的音乐一致，就什么都不做
	if current_player.stream == audio: return 
	# 计算下一个音轨(限制在0和1)
	var next_track: int = wrapi(current_track + 1, 0, 2)
	# 获得下一个播放器
	var next_player: AudioStreamPlayer = get_music_player(next_track)
	# 将下一个播放器的音频设置为给定的音乐并播放
	next_player.stream = audio
	next_player.play()
	
	# 先清空现有的补间动画
	for t in music_tweens:
		t.kill()
	music_tweens.clear()
	
	# 创建补间动画处理音乐的淡入淡出
	fade_track_out(current_player)
	fade_track_in(next_player)
	
	
	# 将下一轨播放器设置为当前播放器
	current_track = next_track




# 根据数字获取背景音乐播放器
func get_music_player(i: int) -> AudioStreamPlayer:
	if i == 0:
		return bgm_player_1
	else:
		return bgm_player_2



# 淡出播放器音乐
func fade_track_out(player: AudioStreamPlayer):
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 0, 1.5)
	tween.tween_callback(player.stop)




# 淡入播放器音乐
func fade_track_in(player: AudioStreamPlayer):
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 1.0, 1.0)






# 设置混响效果
func set_reverb(type: REVERB_TYPE):
	# 获取混响效果
	var reverb_fx: AudioEffectReverb = AudioServer.get_bus_effect(1, 0)
	if not reverb_fx: return
	# 启用混响效果
	AudioServer.set_bus_effect_enabled(1, 0, true)
	
	match type:
		REVERB_TYPE.NONE:
			AudioServer.set_bus_effect_enabled(1, 0, false)
		REVERB_TYPE.SMALL:
			reverb_fx.room_size = 0.2
		REVERB_TYPE.MEDIUM:
			reverb_fx.room_size = 0.5
		REVERB_TYPE.LARGE:
			reverb_fx.room_size = 0.8





# 播放2D空间音效
func play_spatial_sound(audio: AudioStream, pos: Vector2):
	# 创建2D音频播放器，添加并设置属性后播放
	var ap: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(ap)
	ap.bus = "SFX"
	ap.global_position = pos
	ap.stream = audio
	ap.finished.connect(ap.queue_free)
	ap.play()
	
