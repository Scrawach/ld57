extends Scenario

@export var player: Player

func execute() -> void:
	await wait(1)
	
	for dialogue in get_dialogues():
		player.phrase.say(dialogue)
		await wait(2)
	
	await show_tooltip("You can walk on [W], [A], [S], [D]", 4)
	await show_tooltip("[SPACE] for jump", 2)

func get_dialogues() -> Array[String]:
	return [
		"- Ugh, the work day is finally over.",
		"- It's time to go home."
	]
