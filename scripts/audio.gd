extends AudioStreamPlayer

export (String) var sounds_path

onready var ui = list_sounds_in_directory(sounds_path + "ui/")
onready var upgrades = list_sounds_in_directory(sounds_path + "upgrades/")
onready var dialogue = list_sounds_in_directory(sounds_path + "dialogue/")
onready var door_unlocks = list_sounds_in_directory(sounds_path + "door_unlocks/")
onready var door_knocks = list_sounds_in_directory(sounds_path + "door_knocks/")
onready var gunshots = list_sounds_in_directory(sounds_path + "gunshots/")
onready var footsteps = list_sounds_in_directory(sounds_path + "footsteps/")

onready var request_priority := [ui, upgrades, dialogue, door_unlocks, door_knocks, gunshots, footsteps]

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

func get_file_paths_in_folder(folder_path: String) -> Array:
	
	var file_paths := []
	
	var dir := Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin(true, true)
	
	while true:
		var file := dir.get_next()
		if file == "":
			break
		if !file.ends_with(".import"):
			continue 
		file_paths.append(folder_path + file.replace(".import", ""))

	dir.list_dir_end()

	return file_paths

func list_sounds_in_directory(path) -> Array:
	var sounds = []

	for sound in get_file_paths_in_folder(path):
		sounds.append(load(sound))

	return sounds
