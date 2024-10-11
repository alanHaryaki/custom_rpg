extends Area2D

class_name PickableObject

func _ready() -> void:
	scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	var random_vector = Vector2(randi_range(-30, 30), randi_range(-30, 30))
	tween.tween_property(self, "position", position + random_vector, 0.6)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Pickup.play()
		hide()
		await $Pickup.finished
		queue_free()
