class_name EatZone
extends Interaction

signal eated(item: ItemResource)

@onready var label := $Label3D as Label3D

var inventory: Inventory
var is_disabled: bool = false

func enable() -> void:
	is_disabled = false

func disable() -> void:
	is_disabled = true
	hide_tooltip(null)

func show_tooltip(player: Player) -> void:
	if is_disabled:
		return
	
	inventory = player.inventory
	inventory.item_selected.connect(_on_item_selected)
	if player.inventory.is_selected_item():
		label.show()

func hide_tooltip(player: Player) -> void:
	if is_disabled:
		return
	
	inventory.item_selected.disconnect(_on_item_selected)
	label.hide()

func interact(player: Player) -> void:
	if not is_disabled and inventory.is_selected_item():
		var item: ItemResource = inventory.pop_selected_item()
		eated.emit(item)

func _on_item_selected(item_index: int) -> void:
	if inventory.is_selected_item():
		label.show()
	else:
		label.hide()
