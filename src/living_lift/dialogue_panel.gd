class_name DialoguePanel
extends Node3D

@onready var label: Label = %Label
@onready var status: Control = %Status

@onready var health_bar: ReactiveBar = %"Health Bar"
@onready var hunger_bar: ReactiveBar = %"Hunger Bar"

func show_text(text: String) -> void:
	label.show()
	status.hide()
	
	label.text = text

func show_status() -> void:
	label.hide()
	status.show()

func attach(lift: LivingLift) -> void:
	health_bar.construct(lift.health)
	hunger_bar.construct(lift.hunger)
