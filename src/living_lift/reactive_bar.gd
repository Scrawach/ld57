class_name ReactiveBar
extends HBoxContainer

@onready var progress_bar: ProgressBar = %ProgressBar

var reactive_value: ReactiveValue
var tween: Tween

func construct(value: ReactiveValue) -> void:
	self.reactive_value = value
	value.updated.connect(_on_value_updated)
	_on_value_updated(value)

func force_change(target_value: int, duration: float) -> void:
	if tween != null:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(progress_bar, "value", target_value, duration)
	tween.parallel().tween_property(progress_bar, "max_value", reactive_value.max, duration)

func _on_value_updated(value: ReactiveValue) -> void:
	force_change(value.current, 0.5)
