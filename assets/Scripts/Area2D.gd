extends Area2D

var prev_scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(prev_scene)
	#print(get_parent().get_name())
	Global.set_prev(get_parent().get_name())
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_name().contains("Player"):
			if get_parent().get_name().contains("1"):
				if get_name().contains("boss"):
					get_tree().change_scene_to_file("res://assets/Scenes/boss_room.tscn")
				else:
					get_tree().change_scene_to_file("res://assets/Scenes/Main.tscn")
			else:
				get_tree().change_scene_to_file("res://assets/Scenes/Level_1.tscn")
			
	

func get_previous():
	return prev_scene
