class_name ReactiveBar
extends HBoxContainer

@onready var progress_bar: ProgressBar = %ProgressBar

var tween: Tween

func construct(value: ReactiveValue) -> void:
	value.updated.connect(_on_value_updated)
	_on_value_updated(value)

func _on_value_updated(value: ReactiveValue) -> void:
	if tween != null:
		tween.kill()
	
	progress_bar.max_value = value.max
	tween = create_tween()
	tween.tween_property(progress_bar, "value", value.current, 0.5)
