extends Marker2D

var arrow_scene: PackedScene = preload("res://Scenes/Projectiles/arrow.tscn")

@onready var character: CharacterBody2D = get_parent().get_parent()

func _ready() -> void:
	pass

func shoot(_target_position: Vector2, _counteract: int, _bleed: int) -> void:
	var arrow_temp: Area2D = arrow_scene.instantiate()
	arrow_temp.direction = _target_position
	arrow_temp.owner_name = character.friendly_group_name
	arrow_temp.look_at(_target_position)
	arrow_temp.counteract = _counteract
	arrow_temp.bleed = _bleed
	#arrow_temp.damage = Game.item_equipped.item_damage
	arrow_temp.global_position = global_position
	character.world.projectiles.add_child(arrow_temp)
