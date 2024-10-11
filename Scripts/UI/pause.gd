extends UI

func _ready() -> void:
	hide()

func display() -> void:
	get_tree().paused = true
	show()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()
