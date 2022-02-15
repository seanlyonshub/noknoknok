extends CanvasLayer

onready var doors_unlocked = get_node("doors_unlocked")
onready var timer = get_node("timer")

func initialize() -> void:
	Globals.doors_unlocked = 0
	Globals.time_in_minutes = 0
	Globals.string_seconds = "00"

func update_labels() -> void:
	doors_unlocked.text = str(Globals.doors_unlocked) + "/" + str(Globals.total_doors)
	timer.text = str(Globals.time_in_minutes) + ":" + Globals.string_seconds
