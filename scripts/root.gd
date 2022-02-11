extends Node2D

var doors_unlocked : int
var total_doors : Array

var time_in_seconds : int
var time_in_minutes : int

var string_seconds : String = "00"

onready var animations = get_node("animations")
onready var foreground = get_node("foreground")
onready var audio = get_node("audio")
onready var timer = get_node("timer")
onready var ui = get_node("ui")

func _ready() -> void:
	get_tree().paused = false
	timer.play("second")

	ui.get_node("doors_unlocked").text = str(doors_unlocked) + "/" + str(total_doors.size())
	ui.get_node("timer").text = str(time_in_minutes) + ":" + string_seconds

func invert_palette() -> void:
	timer.stop()
	get_tree().paused = true
	animations.play("death_shake")

func add_doors_unlocked() -> void:
	doors_unlocked += 1
	ui.get_node("doors_unlocked").text = str(doors_unlocked) + "/" + str(total_doors.size())

	if !animations.is_playing():
		animations.play("add_doors_unlocked")

	if doors_unlocked == total_doors.size():
		get_tree().reload_current_scene()

func has_second_passed() -> void:
	time_in_seconds += 1
	time_in_seconds %= 60

	ui.get_node("timer").text = str(time_in_minutes) + ":" + string_seconds

	if time_in_seconds < 10:
		string_seconds = "0" + str(time_in_seconds)
	else:
		string_seconds = str(time_in_seconds)

	if time_in_seconds % 60 == 0:
		time_in_minutes += 1

	timer.play("second")
