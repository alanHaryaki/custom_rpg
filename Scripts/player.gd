extends Character

var default_texture: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0085.png")
var armor1: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0098.png")
var armor2: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0097.png")
var armor3: Texture2D = preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0096.png")

var armor: int: set = set_armor
var gold: int: set = set_gold

func _init() -> void:
	hostile_group_name = "monster"
	friendly_group_name = "player"

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

func attack_check(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		var target_position: Vector2 = (get_global_mouse_position() - weapon_marker.global_position).normalized()
		if not attacking_melee and melee_weapon.visible:
			melee_attack(target_position)
		if not attacking_ranged and ranged_weapon.visible:
			ranged_attack(target_position)
	if Input.is_action_just_pressed("block"):
		if AbilityData.AbilityName.BLOCK in abilities:
			if not attacking_melee and not is_blocking:
				if melee_weapon.visible:
					block()

func melee_attack(_target_position: Vector2):
	$Sword.play()
	super(_target_position)

func take_damage(_damage: int) -> void:
	$Hit.play()
	super(_damage)

func set_health(_health) -> void:
	super(_health)
	
	if health <= 0:
		dying = true
		world.game_over()

func set_armor(_armor: int) -> void:
	
	armor = min(3, _armor)
	
	match armor:
		0:
			sprite.texture = default_texture
			defense = 0
			speed = default_speed
		1:
			sprite.texture = armor1
			defense = 1 
			speed = default_speed - 5
		2:
			sprite.texture = armor2
			defense = 2
			speed = default_speed - 10
		3:
			sprite.texture = armor3
			defense = 3
			speed = default_speed - 15

func set_gold(_gold) -> void:
	gold = _gold

func get_random_item() -> void:
	var randi: int = randi_range(1, 4)
	item_equipped = Game.items[randi]

func drop_item(item_num) -> void:
	var item_temp: Area2D = item_scene.instantiate()
	item_temp.item_override(item_num)
	item_temp.global_position = global_position
	world.objects.add_child(item_temp)
