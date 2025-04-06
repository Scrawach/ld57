class_name Doors
extends StaticBody3D

const OPEN_ANIMATION: String = "open"

@onready var collision: CollisionShape3D = $CollisionShape3D

@onready var door_left: Node3D = $"Door Left"
@onready var door_right: Node3D = $"Door Right"

@onready var animation: AnimationPlayer = $AnimationPlayer

var is_closed: bool = true

func open() -> void:
	if not is_closed:
		return
	
	collision.disabled = true
	animation.play(OPEN_ANIMATION)
	is_closed = false

func close() -> void:
	if is_closed:
		return
	
	collision.disabled = false
	animation.play_backwards(OPEN_ANIMATION)
	is_closed = true
