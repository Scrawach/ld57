extends Scenario

@export var player: Player

func execute() -> void:
	await wait(1)
	show_tooltip("You can walk on [w, a, s, d]")
	for dialogue in get_dialogues():
		player.phrase.say(dialogue)
		await wait(2)

func get_dialogues() -> Array[String]:
	return [
		"- Ugh, the work day is finally over.",
		"- It's time to go home."
	]
