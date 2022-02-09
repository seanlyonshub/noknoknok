extends Node2D

export (NodePath) var audio_player_path
export (PackedScene) var bullet
export (int) var speed
export (int) var fire_rate
export (int) var ammo

var shot : bool

onready var audio_player = get_node(audio_player_path)
onready var animations = get_node("animations")
onready var barrel = get_node("barrel")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(get_parent().target):
		look_at(get_parent().target_position)

func shoot() -> void:
	if !shot:
		ammo -= 1

		var new_bullet = bullet.instance()
		self.owner.add_child(new_bullet)

		new_bullet.position = barrel.global_position
		new_bullet.rotation = rotation
		new_bullet.velocity = (get_parent().velocity.normalized() * speed)

		audio_player.request(audio_player.gunshots)
		animations.play("shoot")
		shot = true

func has_shot() -> void:
	shot = false
