extends Node3D
class_name EnemySfxPlayer3D

@onready var vocal_player: AudioStreamPlayer3D = $vocal_player
@onready var ability_player: AudioStreamPlayer3D = $ability_player

##Attacks
@export var attacks: AudioStreamRandomizer

##Hurt
@export var hurts: AudioStreamRandomizer

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
    pass


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

func on_swing() -> void:
    await get_tree().create_timer(0.5).timeout
    ability_player.stream = attacks
    ability_player.play(0.0)

func hurt() -> void:
    vocal_player.stream = hurts
    vocal_player.play(0.0)

func die() -> void:
    GlobalSignalBus.enemy_died.emit()
    vocal_player.stream = death
    vocal_player.play(0.0)

func on_death() -> void:
    SoundManager.play_sound(death)
