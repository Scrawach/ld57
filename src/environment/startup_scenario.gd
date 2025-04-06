extends Scenario

@export var living_lift: LivingLift
@export var world: World
@export var timer_delay: float = 2
@export var player: Player

func execute() -> void:
	await player_into_elevator()
	living_lift.close_doors()
	player.set_physics_process(false)
	
	await wait(1)
	player.phrase.say("Doors?..", 1)
	await wait(1)
	
	player_look_to_monitor()
	await elevator_says(get_startup_panel_text())
	await wait(1)
	
	world.move_to_level(1)
	player.set_physics_process(true)
	player.phrase.say("W-where are you going?..")
	await wait(1)
	await elevator_says(get_rules_text())
	living_lift.dialogue_panel.show_status()

func elevator_says(content: Array[String]) -> void:
	for item in content:
		living_lift.dialogue_panel.show_text(item)
		await wait(timer_delay)

func player_look_to_monitor() -> void:
	var monitor_position: Vector3 = living_lift.dialogue_panel.position
	monitor_position.y = player.position.y
	player.look_at(monitor_position, Vector3.UP, true)

func player_into_elevator() -> void:
	while true:
		await tick()
		
		var distance = player.global_position.distance_to(living_lift.global_position)
		if distance < 1:
			return

func get_startup_panel_text() -> Array[String]:
	return [
		"I. WANT. EAT.",
		"GIVE. ME. EAT.",
		"OR. I. EAT. YOU."
	]

func get_rules_text() -> Array[String]:
	return [
		"I. TRANSPORT. YOU.",
		"ON. FIRST. FLOOR.",
		"IF. YOU. FEED. ME."
	]
