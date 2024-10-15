extends UI

func _ready() -> void:
	display()

func _on_play_pressed() -> void:
	close()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
