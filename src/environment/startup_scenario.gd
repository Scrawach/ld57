extends Scenario

@export var living_lift: LivingLift
@export var world: World
@export var timer_delay: float = 2
@export var player: Player

func execute() -> void:
	await player_into_elevator()
	living_lift.close_doors()
	player.animation.play(player.IDLE_ANIMATION, 0.1)
	player.set_physics_process(false)
	await wait(1)
	player.phrase.say("Automated... Doors?..", 1)
	await wait(1)
	
	player_look_to_monitor()
	await elevator_says(get_startup_panel_text())
	
	world.move_to_level(1)
	player.set_physics_process(true)
	player.phrase.say("W-where are you going?..", 4)
	await wait(4)
	await elevator_says(get_rules_text())
	player.phrase.say("O-okay...", 2)
	living_lift.dialogue_panel.show_status()
	await wait(3)
	await show_tooltip("Find meal on level and feed elevator.", 4)
	await show_tooltip("You can pickup meal on [E]", 4)
	
	await while_elevator_eated()
	await show_tooltip("Use the lever to start the elevator.", 6)
	await show_tooltip("When the elevator is hungry, it won't move.", 6)
	await show_tooltip("Use dash [SHIFT] to move quickly.", 6)
	await show_tooltip("Get to the first floor.", 4)
	await show_tooltip("Good Luck.", 3)
	

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
		if distance < 2:
			return

func while_elevator_eated() -> void:
	while true:
		await tick();
		
		if living_lift.hunger.current > 0:
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
