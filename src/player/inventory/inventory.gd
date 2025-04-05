class_name Inventory
extends Node

signal updated()
signal item_selected(item_index: int)

@export var size: int

var items: Array[ItemResource]
var selected_item: int = -1

func has_empty_space() -> bool:
	return items.size() < size

func is_not_empty() -> bool:
	return items.size() > 0

func is_selected_item() -> bool:
	return selected_item != -1 && items.size() > selected_item

func add_item(item: ItemResource) -> void:
	items.append(item)
	updated.emit()

func pop_selected_item() -> ItemResource:
	if not is_selected_item():
		return null
	var item = items[selected_item]
	items.erase(item)
	updated.emit()
	return item

func select(item_index: int) -> void:
	selected_item = item_index
	item_selected.emit(item_index)
