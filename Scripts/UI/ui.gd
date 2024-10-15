extends CanvasLayer

class_name UI

@onready var world: Node2D = get_tree().root.get_node("World")

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	hide()

func display() -> void:
	get_tree().paused = true
	show()

func close() -> void:
	get_tree().paused = false
	hide()
