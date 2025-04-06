class_name FollowingCamera
extends Camera3D

@export var target: Node3D
@export var offset: Vector3
@export var get_offset_on_ready: bool


func _ready() -> void:
	if get_offset_on_ready:
		offset = global_position - target.global_position

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if target == null:
		return
	
	position = target.global_position + offset

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_delta = event.relative
		rotate_y(deg_to_rad(-mouse_delta.x * 0.1))
		$Arm.rotate_x(deg_to_rad(mouse_delta.y * 0.1))
