class_name CameraRoot
extends Node3D

@export var player: Player

@onready var arm: SpringArm3D = $"Camera Yaw/Camera Pitch/SpringArm3D"
@onready var yaw_node: Node3D = $"Camera Yaw"
@onready var pitch_node: Node3D = $"Camera Yaw/Camera Pitch"
@onready var animation: AnimationPlayer = %"Camera Shake"
@onready var camera: Camera3D = %Camera3D

var yaw: float 
var pitch: float = 45

var position_offset : Vector3 = Vector3(0, 1.3, 0)
var position_offset_target : Vector3 = Vector3(0, 1.3, 0)

var yaw_sensitivity : float = 0.1
var pitch_sensitivity : float = 0.1
var yaw_acceleration : float = 20
var pitch_acceleration : float = 20
var pitch_max : float = 75
var pitch_min : float = -55


func _ready() -> void:
	arm.add_excluded_object(player.get_rid())
	top_level = true

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	position_offset = lerp(position_offset, position_offset_target, 4 * delta)
	global_position = lerp(global_position, player.global_position + position_offset, 18 * delta)
	
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)

func shake_middle() -> void:
	animation.play("middle")

func get_root() -> Node3D:
	return camera
