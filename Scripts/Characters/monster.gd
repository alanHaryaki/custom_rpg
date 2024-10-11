extends Character

class_name Monster

var gold_scene: PackedScene = preload("res://Scenes/Objects/Upgrades/gold.tscn")
var armor_upgrade_scene: PackedScene = preload("res://Scenes/Objects/Upgrades/armor_upgrade.tscn")

@onready var player: CharacterBody2D = $"../../../Player"

var direction: Vector2 = Vector2.ZERO

func _init() -> void:
	hostile_group_name = "player"
	friendly_group_name = "monster"

func _physics_process(delta: float) -> void:
	super(delta)
	if is_instance_valid(player) and not dying:
		focus = player.global_position
		direction = (focus - global_position).normalized()
		if position.distance_to(focus) > 30:
			velocity = direction * speed * delta * 100
		else:
			velocity = Vector2.ZERO
		attack_check(delta)
		move_and_slide()

func set_health(_health) -> void:
	super(_health)
	
	if health <= 0:
		dying = true
		get_node("AnimationPlayer").play("death")
		await get_node("AnimationPlayer").animation_finished
		var _randi: int = randi_range(2, 5)
		for i: int in range(_randi):
			var gold_temp: Area2D = gold_scene.instantiate()
			gold_temp.global_position = global_position
			world.objects.add_child(gold_temp)
		var item_temp: Area2D = item_scene.instantiate()
		item_temp.item_override(Game.get_item_index(item_equipped))
		item_temp.global_position = global_position
		world.objects.add_child(item_temp)
		if _randi == 2:
			var armor_upgrade_temp: Area2D = armor_upgrade_scene.instantiate()
			armor_upgrade_temp.global_position = global_position
			world.objects.add_child(armor_upgrade_temp)
		if _randi == 5:
			var potion_temp: Area2D = item_scene.instantiate()
			potion_temp.item_override(0)
			potion_temp.global_position = global_position
			world.objects.add_child(potion_temp)
		queue_free()
