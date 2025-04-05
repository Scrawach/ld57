class_name Doors
extends StaticBody3D

@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var mesh: MeshInstance3D = $Doors

func open() -> void:
	collision.disabled = true
	mesh.hide()

func close() -> void:
	collision.disabled = false
	mesh.show()
