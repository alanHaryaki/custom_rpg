extends Node2D

var monster_scene: PackedScene = preload("res://Scenes/Monsters/cyclops.tscn")
@export var monster_amount: int = 5
func _ready() -> void:
	for i: int in range(monster_amount):
		var monster_temp: CharacterBody2D = monster_scene.instantiate()
		monster_temp.position = Vector2(randi_range(0, 500), randi_range(0, 500))
		add_child(monster_temp)
