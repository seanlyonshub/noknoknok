extends Camera2D

export (NodePath) var player_path

var target_position : Vector2

onready var player = get_node(player_path)

func _physics_process(delta: float) -> void:
	target_position = player.position

	position += (target_position - position) * delta * 16
