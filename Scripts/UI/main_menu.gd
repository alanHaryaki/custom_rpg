extends CanvasLayer

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")