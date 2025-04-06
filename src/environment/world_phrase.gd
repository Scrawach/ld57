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

var message: String
var letter_by_letter_tween: Tween

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func say(text: String, duration: float = 2) -> void:
	if text[0] != "-":
		message = "- " + text
	else:
		message = text
	
	if letter_by_letter_tween:
		letter_by_letter_tween.kill()
	
	letter_by_letter_tween = create_tween()
	letter_by_letter_tween.tween_method(letter_by_letter_show, 0.0, 1.0, duration / 2)
	
	timer.start(duration)
	
	talking_index += 1
	talking_index %= talkings.size()
	var talking: String = talkings[talking_index]
	
	Audio.play(talking, Vector2(1.5, 2))

func letter_by_letter_show(percentage: float) -> void:
	var length = message.length()
	var target_length = int(length * percentage)
	target_length = min(target_length, length)
	var new_string: String
	for index in target_length:
		new_string += message[index]
	phrase_label.text = new_string

func _on_timeout() -> void:
	phrase_label.text = ""
	said.emit()
