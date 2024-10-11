extends CharacterBody2D

var item_scene: PackedScene = preload("res://Scenes/Inventory/item_object.tscn")
var arrow_scene: PackedScene = preload("res://Scenes/Projectiles/arrow.tscn")
@onready var player: CharacterBody2D = $"../Player"
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar
var speed: float = 800.0
var max_health: int = 20
var health: int: set = set_health
@export var attack_cooldown: float = 1.0
var damage: int = 2
var dying: bool = false
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	health = max_health
	$Timer.wait_time = attack_cooldown

func _physics_process(delta: float) -> void:
	if is_instance_valid(player) and not dying:
		direction = (player.global_position - global_position).normalized()
		if position.distance_to(player.position) > 30:
			velocity = direction * speed * delta
		else:
			velocity = Vector2.ZERO
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		move_and_slide()

func take_damage(_damage: int):
	health -= _damage

func set_health(_health) -> void:
	health = _health
	health_bar.update_value()
	
	if health <= 0:
		dying = true
		get_node("AnimationPlayer").play("death")
		await get_node("AnimationPlayer").animation_finished
		var randi: int = randi_range(2, 5)
		for i: int in range(randi):
			var item_temp = item_scene.instantiate()
			item_temp.global_position = global_position
			$"../Objects".add_child(item_temp)
		queue_free()

func _on_timer_timeout() -> void:
	if is_instance_valid(player) and not dying:
		var arrow_temp: Area2D = arrow_scene.instantiate()
		arrow_temp.direction = direction
		arrow_temp.owner_name = "monster"
		arrow_temp.look_at(direction)
		arrow_temp.global_position = global_position
		$"../Projectiles".add_child(arrow_temp)
