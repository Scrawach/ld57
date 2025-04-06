class_name Level
extends Node3D

@onready var elevator_position := %"Elevator Position"
@onready var dead_zone: Area3D = $DeadZone

var offset: Vector3 = Vector3(0, 250, 0)

func get_lift_position() -> Vector3:
	return elevator_position.global_position

func disable_dead_zone() -> void:
	dead_zone.monitoring = false

func enable_dead_zone() -> void:
	dead_zone.monitoring = true

func _ready() -> void:
	dead_zone.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		teleport_player_under_elevator_position(body)

func teleport_player_under_elevator_position(player: Player) -> void:
	player.position = elevator_position.position + offset
	
