class_name StaminaControl
extends Label3D

@export var stamina: Stamina

func _ready() -> void:
	stamina.changed.connect(_on_stamina_changed)

func _on_stamina_changed(current: int, max: int) -> void:
	text = str(current)
