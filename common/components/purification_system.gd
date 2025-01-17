class_name PurificationSystem
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
    print("Altar: Purification system hooked up for ", meshes_to_impact.size(), " meshes")


func _physics_process(delta):
    for mesh in meshes_to_impact:
        var previous_level: float = mesh.get_blend_shape_value(mesh.find_blend_shape_by_name("PurificationProgress"))
        mesh.set_blend_shape_value(mesh.find_blend_shape_by_name("PurificationProgress"), lerp(previous_level, purification_progress, delta))


func set_purification(new_amount: float):
    purification_progress = new_amount
    #apply_purification_to_meshes(purification_progress)
    purification_updated.emit(purification_progress)
    print("Altar: Purifcationsystem set to val: ", purification_progress)
    pass
