extends KinematicBody2D

export (int) var speed
export (int) var acceleration
export (NodePath) var audio_player_path

var velocity : Vector2

var timer : int
var can_timer : bool
var dead := false

var inputs = ["right", "left", "down", "up"]

onready var init_acceleration = acceleration
onready var init_speed = speed
onready var audio_player = get_node(audio_player_path)
onready var animations = get_node("animations")

func _physics_process(delta: float) -> void:
	var input_x = Input.get_action_strength(inputs[0]) - Input.get_action_strength(inputs[1])
	var input_y = Input.get_action_strength(inputs[2]) - Input.get_action_strength(inputs[3])

	for input in inputs:
		if Input.is_action_just_pressed(input):
			can_timer = true
			audio_player.request(audio_player.footsteps)

		if can_timer:
			timer += 1
			acceleration = init_acceleration * 2
			speed = init_speed * 8
			if timer % 15 == 0:
				can_timer = false
		else:
			acceleration = init_acceleration
			speed = init_speed

	velocity.x += (input_x * speed - velocity.x) / acceleration
	velocity.y += (input_y * speed - velocity.y) / acceleration

	for collision in get_slide_count():
		if get_slide_collision(collision).collider != null:
			if get_slide_collision(collision).collider.name.begins_with("door"):
				if get_slide_collision(collision).normal == -velocity.normalized().round():
					if speed > init_speed:
						get_slide_collision(collision).collider.knock()

	velocity = move_and_slide(velocity)

func kill() -> void:
	if !dead:
		audio_player.stream = audio_player.dialogue[2]
		audio_player.play()

		animations.play("kill")
		dead = true

func has_killed() -> void:
	get_tree().reload_current_scene()
