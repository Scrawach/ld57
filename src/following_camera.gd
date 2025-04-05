class_name FollowingCamera
extends Camera3D

@export var target: Node3D
@export var offset: Vector3
@export var get_offset_on_ready: bool


func _ready() -> void:
	if get_offset_on_ready:
		offset = position - target.position

func _process(delta: float) -> void:
	if target == null:
		return
	
	position = target.position + offset
