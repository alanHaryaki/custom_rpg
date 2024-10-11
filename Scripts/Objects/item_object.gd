extends PickableObject

var randi: int
var item_overrided: bool = false

func _ready() -> void:
	super()
	if not item_overrided:
		randi = randi_range(0, Game.items.size() - 1)
		$Sprite2D.texture = Game.items[randi].item_texture

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$"../../GUI/Inventory".add_item(randi)
	super(body)

func item_override(item_index) -> void:
	randi = item_index
	$Sprite2D.texture = Game.items[randi].item_texture
	item_overrided = true
