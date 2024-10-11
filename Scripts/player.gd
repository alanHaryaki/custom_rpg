extends CharacterBody2D

var arrow_scene: PackedScene = preload("res://Scenes/Projectiles/arrow.tscn")
@onready var weapon_marker: Marker2D = $WeaponHolder
@onready var melee_weapon: Area2D = $WeaponHolder/Melee
@onready var ranged_weapon: Marker2D = $WeaponHolder/Ranged
@onready var health_bar: ProgressBar = $HealthBar

@export var speed: int = 80

var dying: bool = false
var attacking_melee: bool = false
var attacking_ranged: bool = false
var max_health: int = 20
var health: int: set = set_health
var damage: int = 2

var attacked_bodies: Array[CharacterBody2D]

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	
	manage_weapon()
	
	if not dying:
		
		weapon_marker.look_at(get_global_mouse_position())
	
	
		if cos(weapon_marker.rotation) > 0:
			$WeaponHolder/Melee/Sprite2D.flip_h = true
			$Sprite2D.flip_h = false
		else:
			$WeaponHolder/Melee/Sprite2D.flip_h = false
			$Sprite2D.flip_h = true
		
		attack_check(delta)
		
		var input_vector := Vector2.ZERO
		input_vector.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
		input_vector.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
		
		velocity = input_vector * speed
		
		move_and_slide()

func _on_melee_body_entered(body: Node2D) -> void:
	# Check for damaging monster
	if attacking_melee and body.is_in_group("monster"):
		if body not in attacked_bodies:
			attacked_bodies.append(body)
		'''if Game.item_equipped:
			body.take_damage(Game.item_equipped.item_damage)
		else:
			body.take_damage(damage)'''

func attack_check(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and not attacking_melee:
		var target_position: Vector2 = (get_global_mouse_position() - weapon_marker.global_position).normalized()
		if not attacking_melee and melee_weapon.visible:
			melee_attack(target_position)
		if not attacking_ranged and ranged_weapon.visible:
			ranged_attack(target_position)

func melee_attack(_target_position: Vector2):
	$Sword.play()
	attacking_melee = true
	attacked_bodies.clear()
	for body: Node2D in melee_weapon.get_overlapping_bodies():
		if body.is_in_group("monster"):
			attacked_bodies.append(body)
			#body.take_damage(Game.item_equipped.item_damage)
	var tween: Tween = create_tween()
	tween.tween_property(weapon_marker, "position", _target_position * 10, 0.2)
	tween.tween_callback(return_default)
	await tween.finished
	for body in attacked_bodies:
		body.take_damage(Game.item_equipped.item_damage)

func return_default() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(weapon_marker, "position", Vector2.ZERO, 0.2)
	await get_tree().create_timer(0.5).timeout
	attacking_melee = false

func _on_timer_timeout() -> void:
	attacking_ranged = false

func ranged_attack(_target_position) -> void:
	$Shoot.play()
	attacking_ranged = true
	$WeaponHolder/Ranged/Timer.start(0.5)
	var arrow_temp: Area2D = arrow_scene.instantiate()
	arrow_temp.direction = _target_position
	arrow_temp.owner_name = "player"
	arrow_temp.look_at(_target_position)
	arrow_temp.damage = Game.item_equipped.item_damage
	arrow_temp.global_position = global_position
	$"../Projectiles".add_child(arrow_temp)

func take_damage(_damage: int) -> void:
	$Hit.play()
	
	health -= _damage

func set_health(_health) -> void:
	health = _health
	health = min(health, max_health)
	health_bar.update_value()
	
	if health <= 0:
		dying = true
		$"../GameOver".game_over()

func manage_weapon() -> void:
	if Game.item_equipped:
		match Game.item_equipped.type:
			ItemData.Type.MELEE:
				melee_weapon.show()
				ranged_weapon.hide()
				melee_weapon.get_node("Sprite2D").texture = Game.item_equipped.item_texture
			ItemData.Type.RANGED:
				melee_weapon.hide()
				ranged_weapon.show()
				ranged_weapon.get_node("Sprite2D").texture = Game.item_equipped.item_texture
			_:
				melee_weapon.hide()
				ranged_weapon.hide()
