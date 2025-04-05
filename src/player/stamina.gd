class_name Stamina
extends Node

signal changed(current: int, max: int)

@export var current: int
@export var max: int

@onready var recovery_timer: Timer = $"Recovery Timer"
@onready var consume_awaiting_timer: Timer = $"Consume Awaiting"

func _ready() -> void:
	recovery_timer.timeout.connect(_on_recovery_timeout)
	consume_awaiting_timer.timeout.connect(_on_consume_awaiting_timeout)

func can_consume(value: int) -> bool:
	return current >= value

func is_full() -> bool:
	return current == max

func consume(value: int) -> void:
	current -= value
	current = max(0, current)
	changed.emit(current, max)
	
	recovery_timer.stop()
	consume_awaiting_timer.start()

func recovery(value: int) -> void:
	current += value
	current = min(current, max)
	changed.emit(current, max)

func _on_recovery_timeout() -> void:
	recovery(5)
	recovery_timer.start()

func _on_consume_awaiting_timeout() -> void:
	recovery_timer.start()
