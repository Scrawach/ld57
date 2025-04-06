class_name Lever
extends Interaction

signal pressed()

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var tooltip: Node3D = $Tooltip

func show_tooltip(player: Player) -> void:
	tooltip.show()

func hide_tooltip(player: Player) -> void:
	tooltip.hide()

func interact(player: Player) -> void:
	press()

func press() -> void:
	animation.play("interact")
	pressed.emit()
