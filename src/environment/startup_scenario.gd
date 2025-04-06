extends Scenario

@export var dialogue_panel: DialoguePanel
@export var timer_delay: float = 2
@export var player: Player

func execute() -> void:
	await player_into_elevator()
	player.set_physics_process(false)
	for item in get_startup_panel_text():
		dialogue_panel.show_text(item)
		await wait(timer_delay)
	dialogue_panel.show_status()
	player.set_physics_process(true)
	

func player_into_elevator() -> void:
	while true:
		await tick()
		
		var distance = player.position.distance_squared_to(dialogue_panel.position)
		print(distance)

func get_startup_panel_text() -> Array[String]:
	return [
		"I. WANT. EAT.",
		"GIVE. ME. EAT.",
		"OR. I. EAT. YOU."
	]
