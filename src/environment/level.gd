class_name Level
extends Node3D

@onready var lift_position := %"Lift Position" as Marker3D

func get_lift_position() -> Vector3:
	return global_position + lift_position.position
