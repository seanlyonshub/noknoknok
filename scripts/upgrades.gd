extends Node2D

export (PackedScene) var upgrade
var upgrade_types = [0, 1]

func place_upgrade(vector: Vector2) -> void:
	upgrade_types.invert()

	var new_upgrade = upgrade.instance()
	add_child(new_upgrade)
	new_upgrade.position = vector

	new_upgrade.type_index = upgrade_types[0]
