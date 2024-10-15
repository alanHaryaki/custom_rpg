extends Node2D

@onready var player: CharacterBody2D = $SpawnManager/Player
@onready var projectiles: Node2D = $Projectiles
@onready var objects: Node2D = $Objects
@onready var inventory: Control = $GUI/Inventory
@onready var ability_selection_screen: CanvasLayer = $AbilitySelection

func game_over() -> void:
	$GameOver.display()

func pause() -> void:
	$Pause.display()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()
