class_name LivingLift
extends Node3D

signal want_next_level()
signal dead()

@export var config: LiftResource

@onready var dialogue_panel: DialoguePanel = %"Dialogue Panel"
@onready var eat_zone: EatZone = $"Eat Zone"
@onready var doors: Doors = $Doors

var health: ReactiveValue
var hunger: ReactiveValue

func _ready() -> void:
	health = ReactiveValue.new(config.startup_health, config.max_health)
	hunger = ReactiveValue.new(config.startup_hunger, config.max_hunger)
	dialogue_panel.attach(self)
	
	eat_zone.eated.connect(_on_eated)

func open_doors() -> void:
	doors.open()
	eat_zone.enable()

func close_doors() -> void:
	eat_zone.disable()
	doors.close()


func _on_eated(item: ItemResource) -> void:
	hunger.current += item.eat_power
	health.current -= item.damage_power
	
	if health.is_empty():
		dead.emit()
		return
	
	if hunger.is_full():
		want_next_level.emit()
