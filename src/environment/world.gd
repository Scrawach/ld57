class_name World
extends Node3D

@onready var levels: Node3D = $Levels
@onready var living_lift: LivingLift = $"Living Lift"
@onready var player: Player = $Player

var previous_level: Level
var current_level: Level
var current_level_index: int = 0

var moving: Tween

func _ready() -> void:
	#player.get_parent().remove_child(player)
	#living_lift.add_child(player)
	current_level = levels.get_child(0) as Level
	
	living_lift.want_next_level.connect(_on_want_next_level)
	living_lift.dead.connect(_on_lift_dead)
	living_lift.open_doors()

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
	var target_level: Level = levels.get_child(level_index) as Level
	current_level = target_level
	target_level.show()
	
	moving = create_tween()
	moving.tween_property(living_lift, "global_position", target_level.get_lift_position(), 5)
	moving.tween_callback(_on_level_started)
	living_lift.dialogue_panel.hunger_bar.force_change(0, 5)
	current_level_index = level_index

func _on_level_started() -> void:
	previous_level.hide()
	living_lift.open_doors()
	living_lift.hunger.current = 0
