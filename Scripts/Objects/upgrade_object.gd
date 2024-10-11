extends PickableObject

func _ready() -> void:
	super()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.armor += 1
	super(body)
