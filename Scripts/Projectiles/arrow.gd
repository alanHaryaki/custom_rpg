extends Area2D

var direction := Vector2.ZERO
var speed: int = 100
var owner_name: String = ""
var damage: int = 1

func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if owner_name == "player" and body.is_in_group("monster"):
		body.take_damage(damage)
		emit_particles()
	elif owner_name == "monster" and body.is_in_group("player"):
		body.take_damage(damage)
		emit_particles()

func emit_particles() -> void:
	$CPUParticles2D.emitting = true
	$Sprite2D.hide()
	await $CPUParticles2D.finished
	queue_free()
