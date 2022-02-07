extends StaticBody2D

onready var collision = get_node("collision")
onready var polygon = get_node("polygon")

func _ready() -> void:
	collision.polygon = polygon.polygon
