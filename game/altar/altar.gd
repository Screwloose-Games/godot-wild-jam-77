extends StaticBody3D

class_name Altar


signal activated
signal purified

@export var assigned_enemies: Array[Node] = []
@export var altar_power: String = ""
@export var checkpoint: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
