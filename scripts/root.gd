extends Node2D

export (String) var intro_path

var total_doors : Array

var time_in_seconds : int
var time_in_minutes : int

onready var animations = get_node("animations")
onready var foreground = get_node("foreground")
onready var audio = get_node("audio")
onready var timer = get_node("timer")
onready var ui = get_node("ui")

func _ready() -> void:
	Globals.total_doors = total_doors.size() * Globals.difficulty

	get_tree().paused = false
	timer.play("second")

	ui.initialize()
	ui.update_labels()

func invert_palette() -> void:
	timer.stop()
	animations.play("death_shake")

func add_doors_unlocked() -> void:
	Globals.doors_unlocked += 1
	ui.update_labels()

	if !animations.is_playing():
		animations.play("add_doors_unlocked")

func has_second_passed() -> void:
	time_in_seconds += 1
	time_in_seconds %= 60

	ui.update_labels()

	if time_in_seconds < 10:
		Globals.string_seconds = "0" + str(time_in_seconds)
	else:
		Globals.string_seconds = str(time_in_seconds)

	if time_in_seconds % 60 == 0:
		Globals.time_in_minutes += 1

	timer.play("second")
