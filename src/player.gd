class_name Player
extends CharacterBody3D

@export var camera: Node3D
@export var movement_speed: int = 250

func _physics_process(delta: float) -> void:
	var movement = get_movement_input(camera) * movement_speed * delta
	var target_velocity = velocity.lerp(movement, delta * 10)
	velocity = target_velocity
	move_and_slide()

func get_movement_input(relative: Node3D) -> Vector3:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, relative.rotation.y)
	return input.normalized()
