extends KinematicBody2D

export (int) var speed
export (int) var dialogue_index

export (bool) var awake = false
export (bool) var chases_npcs = true
export (int) var chase_distance

export (NodePath) var target_path = null
export (NodePath) var gun_path = null

var velocity : Vector2
var random_velocity : Vector2
var target_position : Vector2

var dead := false

var target
var gun
var home

var target_index : int
var timer : int

onready var audio_player = self.owner.get_node("audio")
onready var upgrades = get_parent().get_parent().get_node("upgrades")
onready var animations = get_node("animations")
onready var ray = get_node("ray")

func _ready() -> void:
	if !awake:
		set_physics_process(false)

	if target_path != null:
		target = get_node(target_path)
	if gun_path != null:
		gun = get_node(gun_path)

func awaken() -> void:
	if !is_physics_processing():
		if dialogue_index > -1 and dialogue_index < audio_player.dialogue.size():
			audio_player.stream = audio_player.dialogue[dialogue_index]
			audio_player.play()

			set_physics_process(true)

func kill() -> void:
	if !dead:
		audio_player.stream = audio_player.dialogue[2]
		audio_player.play()

		animations.play("kill")
		dead = true

func has_killed() -> void:
	upgrades.place_upgrade(position)
	get_parent().remove_child(self)
	queue_free()

func _physics_process(_delta: float) -> void:
	if dead:
		return

	target_index = wrapi(target_index, 0, get_parent().get_children().size())

	chase_target()
	wander()

	print(name, ": ", rad2deg(ray.cast_to.angle()))

	timer += 1

	velocity = move_and_slide(velocity)

	if get_collider() != null:
		match get_collider().name.rstrip("0123456789"):
			"door":
				if get_collider() == target:
					target.unlock()
			"player":
				if get_collider() == target:
					target.kill()
			"npc":
				if get_collider() == target:
					target.kill()
			"fire":
				kill()
				get_collider().kill()

func wander() -> void:
	ray.cast_to = target_position - position
	if is_ray_casting_at_wall():
		if timer % 60 == 0:
			randomize()

			var rand_nums = [-1, 1]
			var rand_x = rand_nums[randi() % rand_nums.size()]
			var rand_y = rand_nums[randi() % rand_nums.size()]

			random_velocity = Vector2(rand_x, rand_y) * speed
	else:
		random_velocity = Vector2.ZERO

func chase_target() -> void:
	if is_instance_valid(target):
		target_position = target.position
		velocity = ((target_position - position).normalized() * speed) + random_velocity

		if position.distance_to(target_position) > chase_distance and chase_distance != 0:
			if target_path == null:
				get_next_target()
			else:
				velocity = Vector2.ZERO

		if is_instance_valid(gun):
			if gun.ammo > 0:
				if !is_ray_casting_at_wall() and position.distance_to(target_position) < chase_distance:
					if timer % gun.fire_rate == 0:
						gun.shoot()

			else:
				remove_child(gun)
				gun.queue_free()

	else:
		if chases_npcs and target_path == null:
			get_next_target()
		else:
			target = home

func get_next_target() -> void:
	var npcs = get_parent().get_children()
	var next_target = npcs[target_index]

	if next_target.is_physics_processing():
		if is_node_npc(next_target):
			if next_target.target_path != null:
				target = next_target
			else:
				target_index += 1
		else:
			target = next_target
	else:
		target_index += 1

	if position.distance_to(next_target.position) > chase_distance:
		target_index += 1

func is_node_npc(node) -> bool:
	if node.name.rstrip("0123456789") == "npc":
		return true
	return false

func get_collider():
	for collision_index in get_slide_count():
		var collision = get_slide_collision(collision_index)
		if is_instance_valid(collision.collider):
			return collision.collider
	return null

func is_ray_casting_at_wall() -> bool:
	if ray.is_colliding():
		if ray.get_collider().name.rstrip("0123456789") == "wall":
			return true
	return false
