extends Node2D

export (String) var root_path

var inputs = ["right", "left"]

onready var animations = get_node("animations")
onready var audio = get_node("audio")
onready var ui = get_node("ui2")

func _ready():
	ui.update_labels()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(inputs[0]):
		audio.request(audio.gunshots)
		animations.play("change_scene_right")
		Globals.difficulty = 1
	if Input.is_action_just_pressed(inputs[1]):
		audio.request(audio.door_unlocks)
		animations.play("change_scene_left")
		Globals.difficulty = 0.5

func has_changed_scene() -> void:
	get_tree().change_scene(root_path)
