class_name Monster
extends Node3D

@export var speed := 2
@export var waypoints: Array[Node3D]

@onready var nav_agent := $NavigationAgent3D as NavigationAgent3D

var point_index: int = 0

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		select_next_point()
		return

	var next_position := nav_agent.get_next_path_position()
	var offset := next_position - global_position
	global_position = global_position.move_toward(next_position, delta * speed)

	offset.y = 0
	if not offset.is_zero_approx():
		look_at(global_position + offset, Vector3.UP)

func select_next_point() -> void:
	point_index += 1
	point_index = point_index % waypoints.size()
	set_target_position(waypoints[point_index].position)

func set_target_position(target_position: Vector3) -> void:
	nav_agent.set_target_position(target_position)
