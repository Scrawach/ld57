class_name PickupItem
extends Interaction

@export var item: ItemResource

@onready var tooltip: Label3D = $Label3D


func show_tooltip(_player: Player) -> void:
	tooltip.show()

func hide_tooltip(_player: Player) -> void:
	tooltip.hide()

func interact(player: Player) -> void:
	var inventory: Inventory = player.inventory
	if not inventory.has_empty_space():
		return
	
	inventory.add_item(item)
	Audio.play("res://items/sound/pickup.mp3", Vector2(0.8, 0.9))
	queue_free()
