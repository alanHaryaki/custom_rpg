extends UI

const ABILITY_CARD_SCENE = preload("res://Scenes/Abilities/ability_card.tscn")

func get_available_abilities() -> Array[AbilityData.AbilityName]:
	var _available_abilities: Array[AbilityData.AbilityName] = []
	for ability_name: AbilityData.AbilityName in Game.abilities.keys():
		if ability_name not in world.player.abilities:
			if Game.abilities[ability_name].conditions:
				if Game.abilities[ability_name].conditions.all(func(condition): return condition in world.player.abilities):
					_available_abilities.append(ability_name)
			else:
				_available_abilities.append(ability_name)
	return _available_abilities

func display() -> void:
	super()
	var available_abilities: Array[AbilityData.AbilityName] = get_available_abilities()
	available_abilities.shuffle()
	var abilities_to_choose: Array[AbilityData.AbilityName] = []
	for i: int in range(3):
		if available_abilities:
			abilities_to_choose.append(available_abilities.pop_front())
	display_ability_cards(abilities_to_choose)

func display_ability_cards(_abilities: Array[AbilityData.AbilityName]) -> void:
	clear_ability_cards()
	for ability in _abilities:
		var ability_card: AbilityCard = ABILITY_CARD_SCENE.instantiate()
		ability_card.init(ability)
		$Panel/Abilities.add_child(ability_card)

func clear_ability_cards() -> void:
	for child in $Panel/Abilities.get_children():
		child.queue_free()

func _on_skip_pressed() -> void:
	close()
	world.player.gold -= Game.ability_price
