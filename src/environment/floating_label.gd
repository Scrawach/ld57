class_name FloatingLabel
extends Label3D

@export var amplitude: float = 0.15
@export var speed: float = 0.3

var initial_position: Vector3

func _ready() -> void:
	initial_position = position

func _physics_process(delta: float) -> void:
	position = initial_position + amplitude * Vector3.UP * sin(Time.get_ticks_msec() * delta * speed + position.y)
