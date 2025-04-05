class_name InventoryControl
extends PanelContainer

@export var inventory: Inventory

@onready var container: Control = $MarginContainer/Container
@onready var item_template: PackedScene = preload("res://player/inventory/ui/item.tscn")

var selected_index: int = -1

func _ready() -> void:
	inventory.updated.connect(_on_inventory_updated)
	inventory.item_selected.connect(_on_inventory_item_selected)
	_on_inventory_updated()

func _on_inventory_updated() -> void:
	for child in container.get_children():
		child.queue_free()
	
	for index in inventory.size:
		var instance: ItemControl = item_template.instantiate() as ItemControl
		container.add_child(instance)
		
		if inventory.items.size() > index:
			instance.construct(inventory.items[index])
		
		if index == selected_index:
			instance.select()

func _on_inventory_item_selected(item_index: int) -> void:
	if selected_index != -1:
		get_item(selected_index).unselect()
	
	selected_index = item_index
	get_item(selected_index).select()

func get_item(index: int) -> ItemControl:
	return container.get_child(index) as ItemControl
