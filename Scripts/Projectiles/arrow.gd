extends Area2D

var direction := Vector2.ZERO
var speed: int = 100
var owner_name: String = ""
var damage: int = 3
var can_counteract: bool = true

func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if owner_name == "player" and body.is_in_group("monster"):
		body.take_damage(damage)
		emit_particles()
	elif owner_name == "monster" and body.is_in_group("player"):
		body.take_damage(damage)
		emit_particles()

func _on_area_entered(area: Area2D) -> void:
	if can_counteract:
		if area.is_in_group("projectile") and area.can_counteract:
			if owner_name != area.owner_name:
				emit_particles()

func emit_particles() -> void:
	$CPUParticles2D.emitting = true
	$Sprite2D.hide()
	$CollisionShape2D.disabled = true
	await $CPUParticles2D.finished
	queue_free()
