class_name ItemControl
extends PanelContainer

@export var select_border_color: Color

@onready var icon_rect: TextureRect = $"Icon Rect"
@onready var border_panel: Panel = $Border

var resource: ItemResource

func construct(item: ItemResource) -> void:
	resource = item
	icon_rect.texture = item.icon

func select() -> void:
	border_panel.self_modulate = select_border_color

func unselect() -> void:
	border_panel.self_modulate = Color.BLACK
