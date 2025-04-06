class_name WorldPhrase
extends Node3D

signal said()

@onready var phrase_label: Label3D = $"Phrase Label"
@onready var timer: Timer = $"Phrase Label/Timer"

var talkings: Array[String] = [
	"res://player/sounds/talking.mp3",
	"res://player/sounds/talking2.mp3",
	"res://player/sounds/talking3.mp3",
]

var talking_index: int = -1

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func say(text: String, duration: float = 2) -> void:
	phrase_label.text = text
	timer.start(duration)
	
	talking_index += 1
	talking_index %= talkings.size()
	var talking: String = talkings[talking_index]
	
	Audio.play(talking, Vector2(1.5, 2))

func _on_timeout() -> void:
	phrase_label.text = ""
	said.emit()
