extends StaticBody2D

var type_index : int
var dead : bool

onready var audio_player = get_parent().owner.get_node("audio")
onready var animations = get_node("animations")

func _ready() -> void:
	animations.play("rotate")

func kill() -> void:
	if !dead:
		animations.play("kill")
		audio_player.request(audio_player.upgrades)
		dead = true

func has_killed() -> void:
	get_parent().remove_child(self)
	queue_free()
