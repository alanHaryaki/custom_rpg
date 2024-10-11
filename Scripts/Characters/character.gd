extends CharacterBody2D

class_name Character

var arrow_scene: PackedScene = preload("res://Scenes/Projectiles/arrow.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var weapon_marker: Marker2D = $WeaponHolder
@onready var melee_weapon: Area2D = $WeaponHolder/Melee
@onready var ranged_weapon: Marker2D = $WeaponHolder/Ranged
@onready var health_bar: ProgressBar = $HealthBar
@onready var bleed_timer: Timer = $BleedTimer

@export var default_speed: int = 80
@export var max_health: int = 20

var speed: int = 80
var health: int: set = set_health
var defense: int
var damage: int = 2
var dying: bool = false
var attack_rate: float = 1.0

var bleed_times: int
var item_equipped: ItemData = Game.items[2]
var focus: Vector2

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	manage_weapon()
	
	if not dying:
		
		weapon_marker.look_at(focus)

		if cos(weapon_marker.rotation) > 0:
			$WeaponHolder/Melee/Sprite2D.flip_h = true
			$Sprite2D.flip_h = false
		else:
			$WeaponHolder/Melee/Sprite2D.flip_h = false
			$Sprite2D.flip_h = true

		move_and_slide()

func take_damage(_damage: int):
	_damage = max(1, _damage - defense)
	health -= _damage

func set_health(_health) -> void:
	health = _health
	health = min(health, max_health)
	health_bar.update_value()

func bleed() -> void:
	bleed_times += randi_range(3, 7)
	bleed_timer.start()
	bleed_timer.timeout.connect(_on_bleed_timer_timeout)

func _on_bleed_timer_timeout():
	health -= 2
	bleed_times -= 1
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if bleed_times <= 0:
		bleed_timer.stop()

func _on_attack_cooldown_timeout() -> void:
	pass # Replace with function body.

func manage_weapon() -> void:
	if item_equipped:
		match item_equipped.type:
			ItemData.Type.MELEE:
				melee_weapon.show()
				ranged_weapon.hide()
				melee_weapon.get_node("Sprite2D").texture = item_equipped.item_texture
			ItemData.Type.RANGED:
				melee_weapon.hide()
				ranged_weapon.show()
				ranged_weapon.get_node("Sprite2D").texture = item_equipped.item_texture
			_:
				melee_weapon.hide()
				ranged_weapon.hide()
