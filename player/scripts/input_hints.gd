@icon("res://components/icons/control.svg")
extends Node2D

@onready var fade_anim: AnimationPlayer = $Fade_Anim
@onready var key_label: Label = $Key/Key_Label
@onready var controller_anim: AnimationPlayer = $Key/Controller_Anim


# 控制器按键提示信息
const HINT_MAP: Dictionary = {
	"keyboard": {
		"interact": "E",
		"attack": "J",
		"jump": "K",
		"dash": "Shift",
		"up": "W",
		"down": "S",
	},
	"xbox": {
		"interact": "A",
		"attack": "X",
		"jump": "Y",
		"dash": "B",
		"up": "",
		"down": "",
	},
} 


# 当前控制器类型
var control_type: String = "keyboard"



func _ready() -> void:
	visible = false
	
	Messages.input_hint_changed.connect(_on_input_hint_changed)






func  _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		control_type = "keyboard"
	elif event is InputEventJoypadButton:
		get_controller_type(event.device)





# 获取控制器设备类型
func get_controller_type(device_id: int):
	# 获取使用中的手柄名称
	var n: String = Input.get_joy_name(device_id).to_lower()
	
	if "playstation" in n or "dualsence" in n or "ps" in n:
		control_type = "xbox"
	elif "nintendo" in n:
		control_type = "xbox"
	else:
		control_type = "xbox"
	
	set_process_input(false)





# 控制器提示改变
func _on_input_hint_changed(hint: String):
	
	key_label.text = HINT_MAP[control_type].get(hint, "")
	
	match hint:
		
		"dash":
			if control_type == "keyboard":
				controller_anim.play(control_type + "_key_long")
			else:
				controller_anim.play(control_type + "_key")
		
		"up", "down":
			if control_type == "keyboard":
				controller_anim.play(control_type + "_key")
			else:
				controller_anim.play(control_type + "_" + hint)
		
		_:
			controller_anim.play(control_type + "_key")
	
	
	if hint == "" or hint == "none":
		fade_anim.play("fade_out")
	else:
		fade_anim.play("fade_in")
