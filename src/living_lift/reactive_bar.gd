class_name ReactiveBar
extends HBoxContainer

@onready var progress_bar: ProgressBar = %ProgressBar

func construct(value: ReactiveValue) -> void:
	value.updated.connect(_on_value_updated)
	_on_value_updated(value)

func _on_value_updated(value: ReactiveValue) -> void:
	progress_bar.max_value = value.max
	progress_bar.value = value.current
