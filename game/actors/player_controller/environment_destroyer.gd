extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    get_parent().get_node("Camera3D").environment = null
