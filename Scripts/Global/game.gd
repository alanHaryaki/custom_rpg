extends Node

var items := {
	0: preload("res://Scenes/Inventory/Item Resources/potion.tres"),
	1: preload("res://Scenes/Inventory/Item Resources/dagger.tres"),
	2: preload("res://Scenes/Inventory/Item Resources/great_sword.tres"),
	3: preload("res://Scenes/Inventory/Item Resources/bow.tres"),
	4: preload("res://Scenes/Inventory/Item Resources/sword.tres")
}

func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Assets/kenney_tiny-dungeon/Tiles/tile_0060.png"))

func get_item_index(item: ItemData) -> int:
	for i: int in items.size():
		if items[i].item_name == item.item_name:
			return i
	return -1
