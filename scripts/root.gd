extends Node2D

onready var animations = get_node("animations")
onready var background = get_node("camera")
onready var foreground = get_node("foreground")

onready var background_color = background.modulate
onready var foreground_color = foreground.modulate

onready var palette = [background, foreground]

func invert_palette() -> void:
	animations.play("shake")
	palette.invert()
	palette[0].modulate = background_color
	palette[1].modulate = foreground_color
