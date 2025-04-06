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
	play_door_audio()

func close() -> void:
	if is_closed:
		return
	
	collision.disabled = false
	animation.play_backwards(OPEN_ANIMATION)
	is_closed = true
	play_door_audio()

func play_door_audio() -> void:
	Audio.play("res://living_lift/sounds/door_opened.mp3", Vector2(0.65, 0.75))

func _on_animation_end() -> void:
	Audio.play("res://living_lift/sounds/door_opened_2.mp3", Vector2(0.4, 0.6))
