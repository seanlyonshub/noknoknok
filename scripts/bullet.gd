extends KinematicBody2D

var velocity : Vector2
var dead : bool

onready var animations = get_node("animations")

func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)

	if get_collider() != null:
		kill()
		match get_collider().name.rstrip("0123456789"):
			"npc":
				get_collider().kill()
			"player":
				get_collider().kill()
			"door":
				get_collider().knock()

func kill() -> void:
	if !dead:
		animations.play("kill")
		dead = true

func has_killed() -> void:
	get_parent().remove_child(self)
	queue_free()

func get_collider():
	for collision_index in get_slide_count():
		var collision = get_slide_collision(collision_index)
		if is_instance_valid(collision.collider):
			return collision.collider
	return null
