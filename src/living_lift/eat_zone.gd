class_name EatZone
extends Interaction

signal eated(item: ItemResource)

@onready var label: Label3D = $Label3D as Label3D
@onready var animation: AnimationPlayer = $"../Elevator Model/elevator-torch/AnimationPlayer"
@onready var eating_path: Node3D = $"Eating Node Path"
@onready var eat_awaiting_timer: Timer = $"Eat awaiting"

var inventory: Inventory
var is_disabled: bool = false

func _ready() -> void:
	eat_awaiting_timer.timeout.connect(_on_eat_awaiting_timeout)

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
	if is_disabled or not inventory:
		return
	
	inventory.item_selected.disconnect(_on_item_selected)
	label.hide()

func interact(player: Player) -> void:
	if not is_disabled and inventory.is_selected_item():
		animation.play("open")
		eat_awaiting_timer.stop()
		
		var item: ItemResource = inventory.pop_selected_item()
		animate_eating(item, player)

func animate_eating(item: ItemResource, player: Node3D) -> void:
	var model: Node3D = item.model.instantiate()
	add_child(model)
	model.global_position = player.global_position + Vector3.UP
	
	var tween = create_tween()
	
	for marker in eating_path.get_children():
		tween.tween_property(model, "position", marker.position, 0.2)
		tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(model, "scale", Vector3.ZERO, 0.25)
	tween.tween_callback(func():
		eat_awaiting_timer.start()
		model.queue_free()
		eated.emit(item))

func _on_item_selected(item_index: int) -> void:
	if inventory.is_selected_item():
		label.show()
	else:
		label.hide()

func _on_eat_awaiting_timeout() -> void:
	animation.play_backwards("open")
