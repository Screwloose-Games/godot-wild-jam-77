extends Area3D

signal purification_updated(purification_progress: float)

@export var purification_progress: float = 0.0 : set = set_purification

var meshes_to_impact: Array[MeshInstance3D]


func _ready():
    for sibling in get_parent().get_children():
        if sibling is MeshInstance3D:
            if sibling.find_blend_shape_by_name("PurificationProgress") != -1:
                meshes_to_impact.append(sibling)
            else:
                push_warning("Looking for meshinstance with PurificationProgress blend shape but didnt find one")


func set_purification(new_amount: float):
    purification_progress = new_amount
    apply_purification_to_meshes(purification_progress)
    purification_updated.emit(purification_progress)
    pass


func apply_purification_to_meshes(purification_level: float):
    for mesh in meshes_to_impact:
        mesh.set_blend_shape_value(mesh.find_blend_shape_by_name("PurificationProgress"), purification_level)
