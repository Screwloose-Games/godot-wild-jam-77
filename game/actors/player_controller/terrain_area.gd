extends Area3D
class_name TerrainArea

enum TerrainType {
    NONE,
    GRASS,
    DIRT,
    STONE,
    WATER
}

const TERRAIN_TYPE_COLLISION_LAYER := 128

@export var type: TerrainType = TerrainType.NONE

func _ready():
    collision_mask = 0
    collision_layer = TERRAIN_TYPE_COLLISION_LAYER
