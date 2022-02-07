extends StaticBody2D

export (NodePath) var audio_player_path
export (Array, NodePath) var linked_npcs

var animations_free := true

onready var collision = get_node("collision")
onready var polygon = get_node("polygon")
onready var animations = get_node("animations")
onready var audio_player = get_node(audio_player_path)

func _ready() -> void:
	collision.polygon = polygon.polygon

func knock() -> void:
	if animations_free:
		animations.play("knock")
		audio_player.request(audio_player.door_knocks)
		animations_free = false

func unlock() -> void:
	if animations_free:
		animations.play("unlock")
		audio_player.request(audio_player.door_unlocks)
		animations_free = false

func has_knocked() -> void:
	animations_free = true
	if !linked_npcs.empty():
		unlock()

func has_unlocked() -> void:
	animations_free = true
	if !linked_npcs.empty():
		for linked_npc in linked_npcs:
			get_node(linked_npc).awaken()
			get_node(linked_npc).home = get_parent()

	queue_free()


