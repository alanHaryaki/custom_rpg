extends Node2D

@onready var projectiles: Node2D = $Projectiles
@onready var objects: Node = $Objects
@onready var inventory: Control = $GUI/Inventory

func game_over() -> void:
	$GameOver.display()

func pause() -> void:
	$Pause.display()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()
