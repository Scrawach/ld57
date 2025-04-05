class_name ReactiveValue
extends RefCounted

signal updated(value: ReactiveValue)

var current: int :
	set(value):
		current = value
		updated.emit(self)
	get():
		return current
		
var max: int :
	set(value):
		max = value
		updated.emit(self)
	get():
		return max

func _init(current: int, max: int) -> void:
	self.current = current
	self.max = max

func is_full() -> bool:
	return current == max
