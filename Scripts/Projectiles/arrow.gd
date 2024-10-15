extends Area2D

var direction := Vector2.ZERO
var speed: int = 100
var owner_name: String = ""
var damage: int = 3
var counteract: int = 0
var bleed: int = 0
var is_destroyed: bool = false

func _physics_process(delta: float) -> void:
	if not is_destroyed:
		self.position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if (owner_name == "player" and body.is_in_group("monster")) or (owner_name == "monster" and body.is_in_group("player")):
		body.take_damage(damage)
		if bleed:
			body.bleed()
		emit_particles()
	#elif owner_name == "monster" and body.is_in_group("player"):
		#body.take_damage(damage)
		#emit_particles()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile") and owner_name != area.owner_name:
		if counteract:
			area.emit_particles()
			if counteract < 2:
				emit_particles()

func emit_particles() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$CPUParticles2D.emitting = true
	$Sprite2D.hide()
	await $CPUParticles2D.finished
	queue_free()
