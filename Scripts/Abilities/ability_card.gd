extends MarginContainer

class_name AbilityCard

var ability_name: AbilityData.AbilityName
var ability_data: AbilityData

@onready var world: Node2D = get_tree().root.get_node("World")

func _on_button_pressed() -> void:
	world.player.abilities.append(ability_name)
	world.player.gold -= Game.ability_price
	world.ability_selection_screen.close()
	

func init(_ability_name: AbilityData.AbilityName) -> void:
	ability_name = _ability_name
	ability_data = Game.abilities[ability_name]
	$VBoxContainer/TextureRect.texture = ability_data.ability_texture
	$VBoxContainer/Name.text = str(AbilityData.AbilityName.keys()[ability_name])
	$VBoxContainer/Description.text = ability_data.description
