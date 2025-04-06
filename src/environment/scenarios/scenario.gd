class_name Scenario
extends Node

@export var tooltip: GlobalTooltip

func execute() -> void:
	await tick()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func tick() -> Signal:
	return get_tree().physics_frame

func show_tooltip(text: String, duration: float = 2) -> void:
	tooltip.show_text(text, duration)
