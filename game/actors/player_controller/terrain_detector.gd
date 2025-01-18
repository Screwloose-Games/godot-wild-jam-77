extends Area3D
class_name TerrainDetector

var current_terrain_type: TerrainArea.TerrainType

func _ready() -> void:
    collision_layer = 0
    collision_mask = TerrainArea.TERRAIN_TYPE_COLLISION_LAYER
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area3D):
    if area is TerrainArea:
        current_terrain_type = area.type
        print(area.TerrainType, current_terrain_type)

func _on_area_exited(area: Area3D):
    if area is TerrainArea:
        var overlapping = get_overlapping_areas()
        if overlapping.size() <= 0:
            current_terrain_type = TerrainArea.TerrainType.NONE
