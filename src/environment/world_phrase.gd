class_name WorldPhrase
extends Node3D

signal said()

@onready var phrase_label: Label3D = $"Phrase Label"
@onready var timer: Timer = $"Phrase Label/Timer"

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func say(text: String, duration: float = 2) -> void:
	phrase_label.text = text
	timer.start(duration)

func _on_timeout() -> void:
	phrase_label.text = ""
	said.emit()
