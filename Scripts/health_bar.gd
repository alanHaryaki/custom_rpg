extends ProgressBar

@onready var character: CharacterBody2D = $".."

func _ready() -> void:
	update_max_value()
	update_value()

func update_max_value() -> void:
	max_value = character.max_health
	size.x = max_value
	position.x = - 0.5 * size.x

func update_value() -> void:
	value = character.health
