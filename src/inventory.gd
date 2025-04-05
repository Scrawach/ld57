class_name Inventory
extends Node

signal updated()
signal item_selected(item_index: int)

@export var size: int

var items: Array[ItemResource]

func has_empty_space() -> bool:
	return items.size() < size

func add_item(item: ItemResource) -> void:
	items.append(item)
	updated.emit()

func select(item_index: int) -> void:
	item_selected.emit(item_index)
