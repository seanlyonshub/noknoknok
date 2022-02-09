extends AudioStreamPlayer

export (Array, Resource) var upgrades
export (Array, Resource) var dialogue
export (Array, Resource) var door_unlocks
export (Array, Resource) var door_knocks
export (Array, Resource) var gunshots
export (Array, Resource) var footsteps

onready var request_priority := [upgrades, dialogue, door_unlocks, door_knocks, gunshots, footsteps]

func request(request: Array) -> void:
	if !playing:
		request.invert()
		stream = request[0]
		play()

	if request_priority.find(request) < request_priority.find(check_stream_array()):
		request.invert()
		stream = request[0]
		play()

func check_stream_array() -> Array:
	for array in request_priority:
		for sound in array:
			if stream == sound:
				return array
	return []
