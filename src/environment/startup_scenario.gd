extends Node

@export var dialogue_panel: DialoguePanel
@export var timer_delay: float = 2

func _ready() -> void:
	dialogue_panel.show_status()

func start() -> void:
	for item in get_startup_panel_text():
		dialogue_panel.show_text(item)
		await get_tree().create_timer(timer_delay).timeout
	dialogue_panel.show_status()

func get_startup_panel_text() -> Array[String]:
	return [
		"I. WANT. EAT.",
		"GIVE. ME. EAT.",
		"OR. I. EAT. YOU."
	]
