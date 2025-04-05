class_name LivingLift
extends Node3D

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
	hunger.current += 10
