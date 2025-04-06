class_name GlobalTooltip
extends PanelContainer

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer

var tween: Tween

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func show_text(text: String, duration: float = 2) -> void:
	show()
	shake()
	label.text = text
	timer.start(duration)

func _on_timer_timeout() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.4
	).set_ease(Tween.EASE_IN_OUT
	).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(func(): hide())

func shake() -> void:
	if tween:
		tween.kill()
	Audio.play("res://environment/ui/sounds/pop2.mp3")
	self.scale = Vector2.ZERO
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING)
