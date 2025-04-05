class_name DialoguePanel
extends Node3D

@onready var label: Label = %Label
@onready var status: Control = %Status

func show_text(text: String) -> void:
	label.text = text
