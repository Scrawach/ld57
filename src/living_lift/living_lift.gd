class_name LivingLift
extends Node3D

signal want_next_level()

@export var config: LiftResource

@onready var dialogue_panel: DialoguePanel = %"Dialogue Panel"
@onready var eat_zone: EatZone = $"Eat Zone"

var health: ReactiveValue
var hunger: ReactiveValue

func _ready() -> void:
	health = ReactiveValue.new(config.startup_health, config.max_health)
	hunger = ReactiveValue.new(config.startup_hunger, config.max_hunger)
	dialogue_panel.attach(self)
	
	eat_zone.eated.connect(_on_eated)

func _on_eated(item: ItemResource) -> void:
	hunger.current += item.eat_power
	health.current -= item.damage_power
	
	if hunger.is_full():
		eat_zone.disable()
		await get_tree().create_timer(1).timeout
		want_next_level.emit()
