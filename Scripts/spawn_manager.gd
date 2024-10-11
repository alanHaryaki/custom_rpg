extends Node2D

var monster_scene: PackedScene = preload("res://Scenes/Characters/Monsters/cyclops.tscn")
@export var monster_amount: int = 5

func _ready() -> void:
	for i: int in range(monster_amount):
		var monster_temp: CharacterBody2D = monster_scene.instantiate()
		monster_temp.global_position = Vector2(randi_range(0, 500), randi_range(0, 500))
		$Monsters.add_child(monster_temp)

func _physics_process(delta: float) -> void:
	while $Monsters.get_child_count() < monster_amount:
		var monster_temp: CharacterBody2D = monster_scene.instantiate()
		monster_temp.global_position = Vector2(randi_range(0, 500), randi_range(0, 500))
		$Monsters.add_child(monster_temp)
