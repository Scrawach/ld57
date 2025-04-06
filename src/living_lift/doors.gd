class_name Doors
extends StaticBody3D

const OPEN_ANIMATION: String = "open"

@onready var collision: CollisionShape3D = $CollisionShape3D

@onready var door_left: Node3D = $"Door Left"
@onready var door_right: Node3D = $"Door Right"

@onready var animation: AnimationPlayer = $AnimationPlayer

func open() -> void:
	collision.disabled = true
	animation.play(OPEN_ANIMATION)

func close() -> void:
	collision.disabled = false
	animation.play_backwards(OPEN_ANIMATION)
