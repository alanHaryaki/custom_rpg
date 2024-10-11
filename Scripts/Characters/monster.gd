extends Character

class_name Monster

var item_scene: PackedScene = preload("res://Scenes/Objects/item_object.tscn")
var upgrade_scene: PackedScene = preload("res://Scenes/Objects/upgrade_object.tscn")

@onready var player: CharacterBody2D = $"../../../Player"

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	super()
	attack_rate = 3
	speed = 8
	$AttackCooldown.wait_time = attack_rate

func _physics_process(delta: float) -> void:
	super(delta)
	if is_instance_valid(player) and not dying:
		focus = player.global_position
		direction = (focus - global_position).normalized()
		if position.distance_to(focus) > 30:
			velocity = direction * speed * delta * 100
		else:
			velocity = Vector2.ZERO
		move_and_slide()

func set_health(_health) -> void:
	super(_health)
	
	if health <= 0:
		dying = true
		get_node("AnimationPlayer").play("death")
		await get_node("AnimationPlayer").animation_finished
		var randi: int = randi_range(2, 5)
		for i: int in range(randi):
			var item_temp = item_scene.instantiate()
			item_temp.global_position = global_position
			$"../../../Objects".add_child(item_temp)
		if randi == 2:
			var upgrade_temp: Area2D = upgrade_scene.instantiate()
			upgrade_temp.global_position = global_position
			$"../../../Objects".add_child(upgrade_temp)
		
		queue_free()

func _on_attack_cooldown_timeout() -> void:
	if is_instance_valid(player) and not dying:
		var arrow_temp: Area2D = arrow_scene.instantiate()
		arrow_temp.direction = direction
		arrow_temp.owner_name = "monster"
		arrow_temp.look_at(direction)
		arrow_temp.global_position = global_position
		$"../../../Projectiles".add_child(arrow_temp)
