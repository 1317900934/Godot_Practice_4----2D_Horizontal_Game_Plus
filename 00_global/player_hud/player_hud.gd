extends CanvasLayer

@onready var hp_margin_container: MarginContainer = $HUD/HP_MarginContainer
@onready var hp_bar: TextureProgressBar = $HUD/HP_MarginContainer/NinePatchRect/HP_Bar



func _ready() -> void:
	Messages.player_hp_changed.connect(update_hp_bar)



func update_hp_bar(hp: float, max_hp: float):
	var value: float = (hp / max_hp) * 100
	hp_bar.value = value
	hp_margin_container.size.x = (max_hp / 3) + 60
