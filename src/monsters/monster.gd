class_name Monster
extends Node3D

const ATTACK_RANGE: float = 0.5
const IDLE_ANIMATION: String = "Idle"
const WALK_ANIMATION: String = "Moving"
const ATTACK_ANIMATION: String = "Attack2"

enum State {
	Idle,
	Chasing,
	Patrol,
	Attack
}

@export var speed := 2
@export var patrol_speed := 4
@export var chase_speed := 4

@export var waypoints: Array[Node3D]

@onready var nav_agent := $NavigationAgent3D as NavigationAgent3D
@onready var chase_timer := $"Chase Timer" as Timer
@onready var awaiting_timer := $"Awaiting Timer" as Timer
@onready var animation: AnimationPlayer = $slime/AnimationPlayer
 
var point_index: int = 0

var player: Node3D
var state: State

func _ready() -> void:
	chase_timer.timeout.connect(_on_chase_timeout)
	awaiting_timer.timeout.connect(_on_awaiting_timeout)
	_switch_to(State.Idle)

func _physics_process(delta: float) -> void:
	match state:
		State.Idle:
			if animation.current_animation != IDLE_ANIMATION:
				animation.play(IDLE_ANIMATION, 0.1)
				
		State.Attack:
			
			if animation.current_animation != ATTACK_ANIMATION:
				animation.play(ATTACK_ANIMATION, 0.1)
			
		State.Chasing:
			_process_chase(delta)
		State.Patrol:
			_process_patrol(delta)

func _on_attack_done() -> void:
	_switch_to(State.Idle)

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body
	_switch_to(State.Chasing)

func _on_area_3d_body_exited(body: Node3D) -> void:
	chase_timer.start()

func _process_attack() -> void:
	pass

func _process_chase(delta: float) -> void:	
	set_target_position(player.global_position)
	_process_movement(delta)
	
	if position.distance_to(player.position) < ATTACK_RANGE:
		_switch_to(State.Attack)
		
		if player is Player:
			var target = player as Player
			target.take_damage()

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
	var look_at_pos = global_position + offset
	if not offset.is_zero_approx() and look_at_pos != self.global_position and look_at_pos != self.position:
		look_at(look_at_pos, Vector3.UP)
	
	if animation.current_animation != WALK_ANIMATION:
		animation.play(WALK_ANIMATION, 0.1)

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


func _on_attack_zone_body_entered(body: Node3D) -> void:
	animation.play(ATTACK_ANIMATION, 0.1)
	#_switch_to(State.Attack)
	if body is Player:
		var target = body as Player
		target.take_damage()
