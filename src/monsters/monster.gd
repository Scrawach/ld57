class_name Monster
extends Node3D

const ATTACK_RANGE: float = 0.5

enum State {
	Idle,
	Chasing,
	Patrol
}

@export var speed := 2
@export var patrol_speed := 4
@export var chase_speed := 4

@export var waypoints: Array[Node3D]

@onready var nav_agent := $NavigationAgent3D as NavigationAgent3D
@onready var chase_timer := $"Chase Timer" as Timer
@onready var awaiting_timer := $"Awaiting Timer" as Timer
 
var point_index: int = 0

var player: Node3D
var state: State

func _ready() -> void:
	chase_timer.timeout.connect(_on_chase_timeout)
	awaiting_timer.timeout.connect(_on_awaiting_timeout)
	_switch_to(State.Idle)

func _physics_process(delta: float) -> void:
	match state:
		State.Chasing:
			_process_chase(delta)
		State.Patrol:
			_process_patrol(delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body
	_switch_to(State.Chasing)

func _on_area_3d_body_exited(body: Node3D) -> void:
	chase_timer.start()

func _process_attack() -> void:
	pass

func _process_chase(delta: float) -> void:	
	set_target_position(player.position)
	_process_movement(delta)
	
	if position.distance_to(player.position) < ATTACK_RANGE:
		print("ATTACK!")

func _on_chase_timeout() -> void:
	_switch_to(State.Idle)
	player = null

func _on_awaiting_timeout() -> void:
	_switch_to(State.Patrol)

func _process_patrol(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		select_next_point()
		_switch_to(State.Idle)
		return

	_process_movement(delta)
	
func _process_movement(delta: float) -> void:
	var next_position := nav_agent.get_next_path_position()
	var offset := next_position - global_position
	global_position = global_position.move_toward(next_position, delta * speed)

	offset.y = 0
	if not offset.is_zero_approx():
		look_at(global_position + offset, Vector3.UP)

func _switch_to(new_state: State) -> void:
	state = new_state
	match state:
		State.Idle:
			awaiting_timer.start()
		State.Patrol:
			speed = patrol_speed
		State.Chasing:
			chase_timer.stop()
			speed = chase_speed

func select_next_point() -> void:
	point_index += 1
	point_index = point_index % waypoints.size()
	set_target_position(waypoints[point_index].position)

func set_target_position(target_position: Vector3) -> void:
	nav_agent.set_target_position(target_position)
