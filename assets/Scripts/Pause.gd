extends MenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_popup().id_pressed.connect(file_menu)

func file_menu(id):
	if id==1:
		get_tree().change_scene_to_file("res://assets/ui/main_menu.tscn")
