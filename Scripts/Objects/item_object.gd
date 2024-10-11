extends PickableObject

var randi: int

func _ready() -> void:
	super()
	randi = randi_range(0, 4)
	$Sprite2D.texture = Game.items[randi].item_texture

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$"../../GUI/Inventory".add_item(randi)
	super(body)
