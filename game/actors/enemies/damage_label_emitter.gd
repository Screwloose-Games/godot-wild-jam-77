extends Node3D

@onready var damage_label: FloatUpLabel3D = %DamageLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func display(amount: float):
    var new_label: FloatUpLabel3D = damage_label.duplicate()
    damage_label.add_sibling(new_label)
    new_label.display(amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
