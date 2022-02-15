extends StaticBody2D

export (bool) var only_on_hard = false

onready var collision = get_node("collision")
onready var polygon = get_node("polygon")

func _ready() -> void:
	collision.polygon = polygon.polygon

	if only_on_hard:
		if Globals.difficulty == 0.5:
			queue_free()
