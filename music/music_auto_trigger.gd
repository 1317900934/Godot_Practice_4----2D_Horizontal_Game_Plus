@icon("res://components/icons/music_trigger.svg")
class_name Music_Auto_Trigger
extends Node


# 音轨
@export var track: AudioStream
# 混响
@export var reverb: Audio.REVERB_TYPE = Audio.REVERB_TYPE.NONE



func _ready() -> void:
	Audio.play_bgm(track)
	Audio.set_reverb(reverb)
