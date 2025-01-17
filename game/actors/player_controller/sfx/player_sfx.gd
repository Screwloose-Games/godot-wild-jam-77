extends Node

@onready var terrain: TerrainDetector = %TerrainDetector

@onready var footstep_player = $footstep_player

@export var dirt_footsteps: AudioStreamRandomizer
@export var grass_footsteps: AudioStreamRandomizer
@export var stone_footsteps: AudioStreamRandomizer
@export var water_footsteps: AudioStreamRandomizer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_footstep():
    if owner.is_on_floor():
        match(terrain.current_terrain_type):
            TerrainArea.TerrainType.DIRT:
                footstep_player.stream = dirt_footsteps
            TerrainArea.TerrainType.GRASS:
                footstep_player.stream = grass_footsteps
            TerrainArea.TerrainType.STONE:
                footstep_player.stream = stone_footsteps
            TerrainArea.TerrainType.WATER:
                footstep_player.stream = water_footsteps
            TerrainArea.TerrainType.NONE:
                footstep_player.stream = dirt_footsteps
            
        footstep_player.play(0.0)

func land_footstep() -> void:
    print("landed")
    _on_footstep()
