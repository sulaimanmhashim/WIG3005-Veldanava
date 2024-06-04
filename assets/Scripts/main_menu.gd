extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://assets/Scenes/Main.tscn")

func _on_about_pressed():
	get_tree().change_scene_to_file("res://assets/ui/about.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://assets/ui/main_menu.tscn")
