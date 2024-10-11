extends TextureRect

class_name InventoryItem

@export var data: ItemData

func _ready() -> void:
	if data:
		expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture = data.item_texture
		tooltip_text = "%s\n%s\nStats: %s Damage %s Defense %s Health" % [data.item_name, data.description, data.item_damage, data.item_defense, data.item_health]
		if data.stackable:
			var label := Label.new()
			label.text = str(data.count)
			label.position = Vector2(24, 16)
			add_child(label)

func init(_data: ItemData) -> void:
	data = _data.duplicate(true)

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_position: Vector2) -> Control:
	var texture_rect := TextureRect.new()
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = size
	texture_rect.modulate.a = 0.5
	texture_rect.position = Vector2(-at_position)
	var control := Control.new()
	control.add_child(texture_rect)
	return control
