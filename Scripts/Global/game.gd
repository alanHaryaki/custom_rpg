extends Node

var items := {
	0: preload("res://Scenes/Inventory/Item Resources/potion.tres"),
	1: preload("res://Scenes/Inventory/Item Resources/dagger.tres"),
	2: preload("res://Scenes/Inventory/Item Resources/great_sword.tres"),
	3: preload("res://Scenes/Inventory/Item Resources/bow.tres"),
	4: preload("res://Scenes/Inventory/Item Resources/sword.tres")
}

var abilities := {
	AbilityData.AbilityName.BLEED: preload("res://Scenes/Abilities/Ability Resources/bleed.tres"),
	AbilityData.AbilityName.BLEED1: preload("res://Scenes/Abilities/Ability Resources/bleed1.tres"),
	AbilityData.AbilityName.BLEED2: preload("res://Scenes/Abilities/Ability Resources/bleed2.tres"),
	AbilityData.AbilityName.BLEED3: preload("res://Scenes/Abilities/Ability Resources/bleed3.tres"),
	AbilityData.AbilityName.BLEED4: preload("res://Scenes/Abilities/Ability Resources/bleed4.tres"),
	AbilityData.AbilityName.BLEED5: preload("res://Scenes/Abilities/Ability Resources/bleed5.tres"),
	AbilityData.AbilityName.BLOCK: preload("res://Scenes/Abilities/Ability Resources/block.tres"),
	AbilityData.AbilityName.COUNTERACT2: preload("res://Scenes/Abilities/Ability Resources/counter2.tres"),
	AbilityData.AbilityName.COUNTERACT: preload("res://Scenes/Abilities/Ability Resources/counter.tres"),
	AbilityData.AbilityName.DEFLECT: preload("res://Scenes/Abilities/Ability Resources/deflect.tres"),
	AbilityData.AbilityName.SLICE: preload("res://Scenes/Abilities/Ability Resources/slice.tres")
}

var ability_price: int = 5

func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0060.png"))

func get_item_index(item: ItemData) -> int:
	for i: int in items.size():
		if items[i].item_name == item.item_name:
			return i
	return -1
