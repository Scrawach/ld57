class_name Player
extends CharacterBody3D

const DASH_STAMINA_REQUIRED: int = 1
const GRAVITY_STRENGTH: int = 20

const IDLE_ANIMATION: String = "Armature|Idle"
const RUN_ANIMATION: String = "Armature|Run"
const JUMP_ANIMATION: String = "Armature|Jump"

@export var camera: Node3D

@export var movement_speed: int = 250
@export var dash_speed: int = 550
@export var jump_strength: int = 5

@onready var inventory: Inventory = $Inventory
@onready var stamina: Stamina = %Stamina
@onready var phrase: WorldPhrase = $"World Phrase"

@onready var model: Node3D = $"Player Model"
@onready var animation: AnimationPlayer = $"Player Model/AnimationPlayer"
@onready var moving_trail: CPUParticles3D = $"Moving Trail"
@onready var landing_trail: CPUParticles3D = $"Landing Trail"

var gravity: float
var previously_floored: bool

var direction: float
var nearest_interaction: Interaction

func _physics_process(delta: float) -> void:
	_interaction_process(delta)
	_animation_process(delta)
	_handle_gravity(delta)
	_movement_process(delta)
	_rotation_process(delta)

func _movement_process(delta: float) -> void:
	var speed = movement_speed
	var movement_input = get_movement_input(camera)
	
	if Input.is_action_pressed("dash") and not movement_input.is_zero_approx() and stamina.can_consume(DASH_STAMINA_REQUIRED):
		speed = dash_speed
		stamina.consume(DASH_STAMINA_REQUIRED)
	
	if speed == dash_speed:
		animation.speed_scale = 2.5
	else:
		animation.speed_scale = 1.5
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	var movement = movement_input * speed * delta
	var target_velocity = velocity.lerp(movement, delta * 10)
	target_velocity.y -= gravity
	velocity = target_velocity
	move_and_slide()

func _rotation_process(delta: float) -> void:	
	if not Vector2(velocity.z, velocity.x).is_zero_approx():
		direction = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, direction, delta * 10)
	
func get_movement_input(relative: Node3D) -> Vector3:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, relative.rotation.y)
	return input.normalized()

func _handle_gravity(delta: float) -> void:
	gravity += GRAVITY_STRENGTH * delta

	if gravity > 0 and is_on_floor():
		gravity = 0

func jump():
	gravity = -jump_strength
	model.scale = Vector3(0.5, 1.4, 0.5)

func _animation_process(delta: float) -> void:
	moving_trail.emitting = false
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 8)
	
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.4, 0.7, 1.4)
		landing_trail.emitting = true
		
	previously_floored = is_on_floor()
	
	if is_on_floor():
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		var speed_factor = horizontal_velocity.length() / movement_speed / delta
		if speed_factor > 0.05:
			if animation.current_animation != RUN_ANIMATION:
				animation.play(RUN_ANIMATION, 0.1)
		elif animation.current_animation != IDLE_ANIMATION:
			animation.play(IDLE_ANIMATION, 0.1)
		
		if speed_factor > 0.4:
			moving_trail.emitting = true
	elif animation.current_animation != JUMP_ANIMATION:
		animation.play(JUMP_ANIMATION, 0.1)

func _interaction_process(delta: float) -> void:
	if nearest_interaction != null and Input.is_action_just_pressed("interact"):
		nearest_interaction.interact(self)
	
	for item_index in inventory.size:
		var is_pressed: bool = Input.is_key_pressed(KEY_1 + item_index)
		
		if is_pressed:
			inventory.select(item_index)

func _on_interact_zone_area_entered(area: Area3D) -> void:
	if area is Interaction:
		if nearest_interaction != null:
			nearest_interaction.hide_tooltip(self)
		
		nearest_interaction = area
		nearest_interaction.show_tooltip(self)


func _on_interact_zone_area_exited(area: Area3D) -> void:
	if nearest_interaction == area:
		nearest_interaction.hide_tooltip(self)
		nearest_interaction = null
