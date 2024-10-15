extends Control

@export var inventory_size: int = 9
@onready var grid: GridContainer = $Grid
@onready var world: Node2D = get_tree().root.get_node("World")
@onready var player: CharacterBody2D = get_tree().root.get_node("World/SpawnManager/Player")

func _ready() -> void:
	for i: int in inventory_size:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32, 32))
		grid.add_child(slot)
	add_item(Game.get_item_index(player.item_equipped))
	#for i: int in Game.items.size():
		#add_item(i)

func add_item(item_index: int) -> void:
	var item = InventoryItem.new()
	item.init(Game.items[item_index])
	if item.data.stackable:
		for i: int in inventory_size:
			if grid.get_child(i).get_child_count() > 0:
				if grid.get_child(i).get_child(0).data.item_name == item.data.item_name:
					if grid.get_child(i).get_child(0).data.count < 99:
						# Add to data count
						grid.get_child(i).get_child(0).data.count += 1
						# Update the label counter
						grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
					break
			else:
				#item.data.count += 1
				grid.get_child(i).add_child(item)
	else:
		for i: int in inventory_size:
			if grid.get_child(i).get_child_count() > 0:
				if grid.get_child(i).get_child(0).data.item_name == item.data.item_name:
					break
			else:
				grid.get_child(i).add_child(item)
