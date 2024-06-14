extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(Global.get_prev())
	if Global.get_prev() != null:
		if Global.get_prev().contains("Level_1"):
			$Player.global_position = Vector2(860, -80)
			Global.set_prev(null)
