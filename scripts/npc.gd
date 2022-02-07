extends KinematicBody2D

export (int) var speed
export (int) var dialogue_index

export (bool) var chases_npcs = true
export (int) var chase_distance

export (NodePath) var target_path = null
export (NodePath) var audio_player_path

var velocity : Vector2
var target_position : Vector2

var dead := false

var target
var target_index : int
var home

onready var audio_player = get_node(audio_player_path)
onready var animations = get_node("animations")

func _ready() -> void:
	set_physics_process(false)

	if target_path != null:
		target = get_node(target_path)

func awaken() -> void:
	if !is_physics_processing():
		if dialogue_index > -1 and dialogue_index < audio_player.dialogue.size():
			audio_player.stream = audio_player.dialogue[dialogue_index]
			audio_player.play()

			set_physics_process(true)

func kill() -> void:
	if !dead:
		audio_player.stream = audio_player.dialogue[3]
		audio_player.play()

		animations.play("kill")
		dead = true

func has_killed() -> void:
	get_parent().remove_child(self)
	queue_free()

func _physics_process(delta: float) -> void:
	chase_target()

	velocity = move_and_slide(velocity)

	for collision in get_slide_count():
		if get_slide_collision(collision).collider != null:
			if get_slide_collision(collision).collider == target:
				match get_slide_collision(collision).collider.get_class():
					"StaticBody2D":
						target.unlock()
					"KinematicBody2D":
						target.kill()

func chase_target() -> void:
	if is_instance_valid(target):
		target_position = target.position
		velocity = (target_position - position).normalized() * speed

		if position.distance_to(target_position) > chase_distance and chase_distance != 0:
			if target_path == null:
				get_next_target()
			else:
				velocity = Vector2.ZERO

	else:
		if chases_npcs and target_path == null:
			get_next_target()
		else:
			target = home

func get_next_target() -> void:
	var npcs = get_parent().get_children()
	npcs.erase(self)

	target_index = wrapi(target_index, 0, npcs.size())

	if position.distance_to(npcs[target_index].position) < chase_distance:
		target = npcs[target_index]
	else:
		target_index += 1
