extends PickableObject

class_name UpgradeObject

var armor_increase: int
var gold_increase: int

func _ready() -> void:
	super()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.armor += armor_increase
		body.gold += gold_increase
	super(body)
