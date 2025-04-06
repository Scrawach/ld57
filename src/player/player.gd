class_name Player
extends CharacterBody3D

const DASH_STAMINA_REQUIRED: int = 1
const GRAVITY_STRENGTH: int = 20
const GRAVITY_BOUND: float = 40

const IDLE_ANIMATION: String = "Armature|Idle"
const RUN_ANIMATION: String = "Armature|Run"
const JUMP_ANIMATION: String = "Armature|Jump"
const JUMP_2_ANIMATION: String = "Armature|Jump_001"

@export var camera: CameraRoot

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

@onready var jumping_availability: Timer = $"Jumping Availability"

var gravity: float
var previously_floored: bool

var direction: float
var nearest_interaction: Interaction

var can_jump: bool
var jump_animations: Array[String] = [JUMP_ANIMATION, JUMP_2_ANIMATION]
var jump_animation_index: int


func _ready() -> void:
	jumping_availability.timeout.connect(_on_jumping_availability_timeout)

func _physics_process(delta: float) -> void:
	_interaction_process(delta)
	_animation_process(delta)
	_handle_gravity(delta)
	_movement_process(delta)
	_rotation_process(delta)

func _movement_process(delta: float) -> void:
	var speed = movement_speed
	var movement_input = get_movement_input(camera.get_root())
	
	if Input.is_action_pressed("dash") and not movement_input.is_zero_approx() and stamina.can_consume(DASH_STAMINA_REQUIRED):
		speed = dash_speed
		stamina.consume(DASH_STAMINA_REQUIRED)
	
	if speed == dash_speed:
		animation.speed_scale = 2.5
	else:
		animation.speed_scale = 1.5
	
	if is_on_floor():
		can_jump = true
	
	if previously_floored and not is_on_floor():
		jumping_availability.start()
	
	previously_floored = is_on_floor()
	
	if Input.is_action_just_pressed("jump") and can_jump:
		jumping_availability.stop()
		can_jump = false
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
	input = input.rotated(Vector3.UP, relative.global_rotation.y )
	return input.normalized()

func _handle_gravity(delta: float) -> void:
	gravity += GRAVITY_STRENGTH * delta
	gravity = min(GRAVITY_BOUND, gravity)

	if gravity > 0 and is_on_floor():
		gravity = 0

func jump():
	_play_start_jump_sound()
	gravity = -jump_strength
	model.scale = Vector3(0.5, 1.4, 0.5)

func _animation_process(delta: float) -> void:
	moving_trail.emitting = false
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 8)
	
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.4, 0.7, 1.4)
		landing_trail.emitting = true
		camera.shake_middle()
		_play_landing_sound()
	
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
	
	elif animation.current_animation != jump_animations[jump_animation_index]:
		jump_animation_index += 1
		jump_animation_index %= jump_animations.size()
		animation.play(jump_animations[jump_animation_index], 0.1)

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

func _on_jumping_availability_timeout() -> void:
	can_jump = is_on_floor()

func _play_start_jump_sound() -> void:
	Audio.play("res://player/sounds/start_jump.mp3", Vector2(0.75, 0.9))

func _play_landing_sound() -> void:
	Audio.play("res://player/sounds/landing.mp3", Vector2(0.55, 0.65))

func _on_step() -> void:
	camera.shake_weak()
	Audio.play("res://player/sounds/step.mp3", Vector2(0.7, 0.9))
