extends CSGCylinder3D


var starting_height = 0
@export var final_height = 4

@export var duration: float = 1

func _ready() -> void:
    visible = false
    height = starting_height
    pass # Replace with function body.

func _on_altar_activated() -> void:
    visible = true
    var tween = get_tree().create_tween()
    tween.tween_property(self, "height", final_height, duration)
