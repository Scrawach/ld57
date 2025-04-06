class_name PlayerHud
extends Node3D

@export var stamina: Stamina
@export var smooth_duration: float = 0.5

@onready var render: Sprite3D = $Sprite3D
@onready var progress_bar: ProgressBar = %"Stamina Progress Bar"
@onready var timer: Timer = $Timer


func _ready() -> void:
	stamina.changed.connect(_on_stamina_changed)
	timer.timeout.connect(_on_timer_timeout)
	
	progress_bar.value = stamina.current
	progress_bar.max_value = stamina.max

func _on_stamina_changed(current: int, max: int) -> void:
	progress_bar.value = current
	progress_bar.max_value = max
	timer.start()
	render.show()

func _on_timer_timeout() -> void:
	render.hide()
