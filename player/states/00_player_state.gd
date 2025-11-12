@icon("res://player/state.svg")

class_name Player_State
extends Node


var player: Player
var next_state: Player_State = null



#region 状态引用
@onready var idle: Player_State_Idle = %Idle
@onready var run: Player_State_Run = %Run
@onready var jump: Player_State_Jump = %Jump
@onready var fall: Player_State_Fall = %Fall

#endregion





# 初始化
func init():
	pass


# 进入状态
func enter():
	pass


# 退出状态
func exit():
	pass


# 用户输入处理
func handle_input(_event: InputEvent) -> Player_State:
	return next_state


# 状态进行
func process(_delta: float) -> Player_State:
	return next_state


# 物理状态进行
func physics_process(_delta: float) -> Player_State:
	return next_state
