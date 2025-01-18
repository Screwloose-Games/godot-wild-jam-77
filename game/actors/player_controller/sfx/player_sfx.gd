extends Node

@onready var vocal_player: AudioStreamPlayer3D = $vocal_player
@onready var ability_player: AudioStreamPlayer3D = $ability_player

##Attacks
@export var attacks: AudioStreamRandomizer

##Dodges
@export var dodges: AudioStreamRandomizer

##Jumps
@export var jumps: AudioStreamRandomizer
@export var double_jumps: AudioStreamRandomizer

##Hits
@export var death: AudioStream

##Footsteps
@onready var terrain: TerrainDetector = %TerrainDetector
@onready var footstep_player = $footstep_player

@export var dirt_footsteps: AudioStreamRandomizer
@export var grass_footsteps: AudioStreamRandomizer
@export var stone_footsteps: AudioStreamRandomizer
@export var water_footsteps: AudioStreamRandomizer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignalBus.player_died.connect(_on_death)


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

func _on_swing() -> void:
    ability_player.stream = attacks
    ability_player.play(0.0)

func _on_jump() -> void:
    vocal_player.stream = jumps
    vocal_player.play(0.0)
    
func _on_double_jump() -> void:
    ability_player.stream = double_jumps
    ability_player.play(0.0)

func _on_dash() -> void:
    ability_player.stream = dodges
    ability_player.play(0.0)

func _on_death() -> void:
    SoundManager.play_sound(death)
