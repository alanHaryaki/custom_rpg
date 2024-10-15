extends CharacterBody2D

class_name Character

var item_scene: PackedScene = preload("res://Scenes/Objects/item_object.tscn")

@onready var world: Node2D = get_tree().root.get_node("World")

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
var abilities: Array[AbilityData.AbilityName]

var attacking_melee: bool = false
var attacked_bodies: Array[CharacterBody2D]
var attacking_ranged: bool = false
var is_blocking: bool = false

var friendly_group_name: String
var hostile_group_name: String

var bleed_times: int
var item_equipped: ItemData
var focus: Vector2

func _ready() -> void:
	health = max_health
	add_to_group(StringName(friendly_group_name), true)
	get_random_item()

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

func attack_check(delta: float) -> void:
	var target_position: Vector2 = (focus - weapon_marker.global_position).normalized()
	if not attacking_melee and melee_weapon.visible:
		melee_attack(target_position)
	if not attacking_ranged and ranged_weapon.visible:
		ranged_attack(target_position)

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
	attacking_melee = false
	attacking_ranged = false

func get_random_item() -> void:
	var randi: int = randi_range(1, 4)
	item_equipped = Game.items[randi]

func manage_weapon() -> void:
	if item_equipped:
		match item_equipped.type:
			ItemData.Type.MELEE:
				melee_weapon.show()
				ranged_weapon.hide()
				melee_weapon.get_node("Sprite2D").texture = item_equipped.item_texture
				melee_weapon.get_node("CollisionShape2D").shape = item_equipped.item_collision_shape
			ItemData.Type.RANGED:
				melee_weapon.hide()
				ranged_weapon.show()
				ranged_weapon.get_node("Sprite2D").texture = item_equipped.item_texture
			_:
				melee_weapon.hide()
				ranged_weapon.hide()

func _on_melee_body_entered(body: Node2D) -> void:
	if attacking_melee and body.is_in_group(hostile_group_name):
		if body not in attacked_bodies:
			attacked_bodies.append(body)

func _on_melee_area_entered(area: Area2D) -> void:
	'''if ItemData.Effect.ARROW_SLICE in item_equipped.item_effects or is_blocking:
		if attacking_melee and area.is_in_group("projectile") and area.owner_name == hostile_group_name:
			area.queue_free()
	elif ItemData.Effect.ARROW_DEFLECT in item_equipped.item_effects:
		if attacking_melee and area.is_in_group("projectile") and area.owner_name == hostile_group_name:
			area.owner_name = friendly_group_name
			area.rotate(PI)
			area.direction = - area.direction'''
	if AbilityData.AbilityName.DEFLECT in abilities:
		area.owner_name = friendly_group_name
		area.rotate(PI)
		area.direction = - area.direction
	elif AbilityData.AbilityName.SLICE in abilities or is_blocking:
		area.queue_free()

func melee_attack(_target_position: Vector2):
	attacking_melee = true
	$AttackCooldown.start(1 /(attack_rate * item_equipped.attack_rate_multiplier))
	attacked_bodies.clear()
	for body: Node2D in melee_weapon.get_overlapping_bodies():
		if body.is_in_group(hostile_group_name):
			attacked_bodies.append(body)
			#body.take_damage(Game.item_equipped.item_damage)
	for area: Area2D in melee_weapon.get_overlapping_areas():
		if area.is_in_group("projectile") and area.owner_name == hostile_group_name:
			#if ItemData.Effect.ARROW_SLICE in item_equipped.item_effects:
			#if ItemData.Effect.ARROW_DEFLECT in item_equipped.item_effects:
			if AbilityData.AbilityName.DEFLECT in abilities:
				area.owner_name = friendly_group_name
				area.rotate(PI)
				area.direction = - area.direction
			elif AbilityData.AbilityName.SLICE in abilities:
				area.queue_free()
			
	var tween: Tween = create_tween()
	tween.tween_property(weapon_marker, "position", _target_position * 10, 0.2)
	tween.tween_callback(return_default)
	await tween.finished
	for body in attacked_bodies:
		if body != null:
			body.take_damage(item_equipped.item_damage)
			#if ItemData.Effect.BLEED in item_equipped.item_effects:
			if AbilityData.AbilityName.BLEED in abilities:
				if AbilityData.AbilityName.BLEED4 in abilities:
					body.bleed()
				else:
					var randi: int = randi_range(1, 5)
					if AbilityData.AbilityName.BLEED3 in abilities:
						if randi <= 4:
							body.bleed()
					elif AbilityData.AbilityName.BLEED2 in abilities:
						if randi <= 3:
							body.bleed()
					elif AbilityData.AbilityName.BLEED1 in abilities:
						if randi <= 2:
							body.bleed()
					else:
						if randi == 1:
							body.bleed()

func return_default() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(weapon_marker, "position", Vector2.ZERO, 0.2)

func ranged_attack(_target_position) -> void:
	$Shoot.play()
	attacking_ranged = true
	var _counteract: int
	if AbilityData.AbilityName.COUNTERACT2 in abilities:
		_counteract = 2
	elif AbilityData.AbilityName.COUNTERACT in abilities:
		_counteract = 1
	else:
		_counteract = 0
	var _bleed: int
	if AbilityData.AbilityName.BLEED5 in abilities:
		_bleed = 1
	else:
		_bleed = 0
	ranged_weapon.shoot(_target_position, _counteract, _bleed)
	$AttackCooldown.start(1 /(attack_rate * item_equipped.attack_rate_multiplier))

func block() -> void:
	is_blocking = true
	for area: Area2D in melee_weapon.get_overlapping_areas():
		if area.is_in_group("projectile") and area.owner_name == hostile_group_name:
			area.queue_free()
	var tween: Tween = create_tween()
	var current_rotation = weapon_marker.rotation
	tween.tween_property(weapon_marker, "rotation", current_rotation + PI/3, 0.2)
	tween.tween_property(weapon_marker, "rotation", current_rotation - 2 * PI/3, 0.2)
	tween.tween_property(weapon_marker, "rotation", current_rotation + PI/3, 0.2)
	await tween.finished
	is_blocking = false
