extends StaticBody2D

var dead : bool

onready var animations = get_node("animations")
onready var collision = get_node("collision")
onready var polygon = get_node("polygon")

func _ready() -> void:
	collision.polygon = polygon.polygon

func kill() -> void:
	if !dead:
		animations.play("kill")
		dead = true

func has_killed() -> void:
	get_parent().remove_child(self)
	queue_free()


