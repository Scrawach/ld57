class_name World
extends Node3D

@export var final_zone: Area3D
@export var final_control: Control

@onready var levels: Node3D = $Levels
@onready var living_lift: LivingLift = $"Living Lift"
@onready var player: Player = $Player

var previous_level: Level
var current_level: Level
var current_level_index: int = 0

var moving: Tween

func _ready() -> void:
	current_level = levels.get_child(0) as Level
	living_lift.want_next_level.connect(_on_want_next_level)
	living_lift.dead.connect(_on_lift_dead)
	living_lift.display_floor(get_next_floor_number())
	final_zone.body_entered.connect(_on_body_entered_at_final_zone)

func get_house_size() -> int:
	return levels.get_child_count()

func get_next_floor_number() -> String:
	var number: int = get_house_size() - current_level_index
	return str(number)

func _on_want_next_level() -> void:
	living_lift.close_doors()
	
	var next_index: int = current_level_index + 1
	if next_index >= levels.get_child_count():
		return
	
	move_to_level(next_index)

func _on_lift_dead() -> void:
	var last_level_index: int = levels.get_child_count() - 1
	move_to_level(last_level_index)

func move_to_level(level_index: int) -> void:	
	living_lift.eat_zone.disable()
	previous_level = current_level
	previous_level.disable_dead_zone()
	var target_level: Level = levels.get_child(level_index) as Level
	current_level = target_level
	target_level.show()
	
	moving = create_tween()
	moving.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	moving.tween_property(living_lift, "global_position", target_level.get_lift_position(), 10)
	moving.tween_callback(_on_level_started)
	current_level.show()
	living_lift.cost_for_elevate()
	current_level_index = level_index

func _on_level_started() -> void:
	previous_level.hide()
	living_lift.open_doors()
	living_lift.display_floor(get_next_floor_number())

func _on_body_entered_at_final_zone(body: Node3D) -> void:
	final_control.show()
