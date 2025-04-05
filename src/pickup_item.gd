class_name PickupItem
extends Interaction

@export var item: ItemResource

func interact(player: Player) -> void:
	var inventory: Inventory = player.inventory
	if not inventory.has_empty_space():
		return
	
	inventory.add_item(item)
	queue_free()
