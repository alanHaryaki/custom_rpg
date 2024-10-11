extends PanelContainer

class_name InventorySlot

@export var type: ItemData.Type
var equipped: bool = false

func init(_type: ItemData.Type, _minimum_size: Vector2) -> void:
	type = _type
	custom_minimum_size = _minimum_size

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		if type == ItemData.Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
				return get_child(0).data.type == data.data.type
		else:
			return data.data.type == type
	else:
		return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	data.reparent(self)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			if get_child_count() > 0:
				# Check for misc item, otherwise equip item in slot
				if get_child(0).data.type == ItemData.Type.MISC:
					var player = get_tree().get_nodes_in_group("player")[0]
					if player.health < player.max_health:
						player.health += get_child(0).data.item_health
						get_child(0).data.count -= 1
						get_child(0).get_child(0).text = str(get_child(0).data.count)
						if get_child(0).data.count <= 0:
							get_child(0).queue_free()
				else:
					Game.item_equipped = get_child(0).data
