extends Node3D
var progress : float
@export var mesh : MeshInstance3D
func _process(delta: float) -> void:
     mesh.set_blend_shape_value(0,progress)
        
    
