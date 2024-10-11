extends Character

var default_texture: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0085.png")
var armor1: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0098.png")
var armor2: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0097.png")
var armor3: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0096.png")

var attacking_melee: bool = false
var attacking_ranged: bool = false
var armor: int: set = set_armor

var attacked_bodies: Array[CharacterBody2D]

func _physics_process(delta: float) -> void:
	focus = get_global_mouse_position()
	
	super(delta)
	
	if not dying:
		
		attack_check(delta)
		
		var input_vector := Vector2.ZERO
		input_vector.x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
		input_vector.y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
		
		velocity = input_vector * speed
		
		move_and_slide()

func _on_melee_body_entered(body: Node2D) -> void:
	if attacking_melee and body.is_in_group("monster"):
		if body not in attacked_bodies:
			attacked_bodies.append(body)
		'''if Game.item_equipped:
			body.take_damage(Game.item_equipped.item_damage)
		else:
			body.take_damage(damage)'''
	
	
func _on_melee_area_entered(area: Area2D) -> void:
	if ItemData.Effect.ARROW_SLICE in item_equipped.item_effects:
		if attacking_melee and area.is_in_group("projectile") and area.owner_name == "monster":
			area.queue_free()
	elif ItemData.Effect.ARROW_DEFLECT in item_equipped.item_effects:
		if attacking_melee and area.is_in_group("projectile") and area.owner_name == "monster":
			area.owner_name = "player"
			area.can_counteract = false
			area.rotate(PI)
			area.direction = - area.direction

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
	for area: Area2D in melee_weapon.get_overlapping_areas():
		if area.is_in_group("projectile") and area.owner_name == "monster":
			if ItemData.Effect.ARROW_SLICE in item_equipped.item_effects:
				area.queue_free()
			elif ItemData.Effect.ARROW_DEFLECT in item_equipped.item_effects:
				area.owner_name = "player"
				area.rotate(PI)
				area.direction = - area.direction
	var tween: Tween = create_tween()
	tween.tween_property(weapon_marker, "position", _target_position * 10, 0.2)
	tween.tween_callback(return_default)
	await tween.finished
	for body in attacked_bodies:
		if body != null:
			body.take_damage(item_equipped.item_damage)
			if ItemData.Effect.BLEED in item_equipped.item_effects:
				body.bleed()

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
	#arrow_temp.damage = Game.item_equipped.item_damage
	arrow_temp.global_position = global_position
	$"../Projectiles".add_child(arrow_temp)

func take_damage(_damage: int) -> void:
	$Hit.play()
	
	super(_damage)

func set_health(_health) -> void:
	super(_health)
	
	if health <= 0:
		dying = true
		$"../GameOver".game_over()

func set_armor(_armor: int) -> void:
	armor = min(3, _armor)
	
	match armor:
		0:
			'''$Sprite2D.show()
			$Armor1.hide()
			$Armor2.hide()
			$Armor3.hide()'''
			sprite.texture = default_texture
			defense = 0
			speed = default_speed
		1:
			'''$Sprite2D.hide()
			$Armor1.show()
			$Armor2.hide()
			$Armor3.hide()'''
			sprite.texture = armor1
			defense = 1 
			speed = default_speed - 5
		2:
			'''$Sprite2D.hide()
			$Armor1.hide()
			$Armor2.show()
			$Armor3.hide()'''
			sprite.texture = armor2
			defense = 2
			speed = default_speed - 10
		3:
			'''$Sprite2D.hide()
			$Armor1.hide()
			$Armor2.hide()
			$Armor3.show()'''
			sprite.texture = armor3
			defense = 3
			speed = default_speed - 15
