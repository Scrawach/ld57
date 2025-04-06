class_name MainScenario
extends Node

func _ready() -> void:
	start()

func start() -> void:
	for scenario in get_children():
		if scenario is Scenario:
			await scenario.execute()
