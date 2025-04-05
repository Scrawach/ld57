class_name Player
extends CharacterBody3D

const DASH_STAMINA_REQUIRED: int = 1

@export var camera: Node3D

@export var movement_speed: int = 250
@export var dash_speed: int = 550

@onready var inventory: Inventory = $Inventory
@onready var stamina: Stamina = %Stamina

var nearest_interaction: Interaction

func _physics_process(delta: float) -> void:
	_interaction_process(delta)
	_movement_process(delta)

func _movement_process(delta: float) -> void:
	var speed = movement_speed
	var movement_input = get_movement_input(camera)
	
	if Input.is_action_pressed("dash") and not movement_input.is_zero_approx() and stamina.can_consume(DASH_STAMINA_REQUIRED):
		speed = dash_speed
		stamina.consume(DASH_STAMINA_REQUIRED)
	
	var movement = movement_input * speed * delta
	var target_velocity = velocity.lerp(movement, delta * 10)
	velocity = target_velocity
	move_and_slide()

func get_movement_input(relative: Node3D) -> Vector3:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, relative.rotation.y)
	return input.normalized()

func _interaction_process(delta: float) -> void:
	if nearest_interaction != null and Input.is_action_pressed("interact"):
		nearest_interaction.interact(self)
	
	for item_index in inventory.size:
		var is_pressed: bool = Input.is_key_pressed(KEY_1 + item_index)
		
		if is_pressed:
			inventory.select(item_index)

func _on_interact_zone_body_entered(body: Node3D) -> void:
	if body is Interaction:
		nearest_interaction = body

func _on_interact_zone_body_exited(body: Node3D) -> void:
	if nearest_interaction == body:
		nearest_interaction = null
