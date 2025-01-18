extends Node3D

@onready var light: DirectionalLight3D = $DirectionalLight3D
@onready var environment: WorldEnvironment = $WorldEnvironment

##Directional light
@export var init_directional_energy: float
@export var init_directional_color: Color
@export var init_directional_rotation: Vector3

@export var cleansed_directional_energy: float
@export var cleansed_directional_color: Color
@export var cleansed_directional_rotation: Vector3

##Environment
@export var init_sky_energy: float
@export var init_ambient_light_energy: float
@export var init_fog_color: Color
@export var init_fog_light_energy: float
@export var init_fog_density: float

@export var cleansed_sky_energy: float
@export var cleansed_ambient_light_energy: float
@export var cleansed_fog_color: Color
@export var cleansed_fog_light_energy: float
@export var cleansed_fog_density: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    ##_on_new_area()
    GlobalSignalBus.changed_level.connect(_on_new_area)
    GlobalSignalBus.altar_succeeded.connect(_on_cleanse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_new_area():
    light.light_energy = init_directional_energy
    light.light_color = init_directional_color
    light.rotation = init_directional_rotation
    
    environment.environment.background_energy_multiplier = init_sky_energy
    environment.environment.ambient_light_energy = init_ambient_light_energy
    environment.environment.fog_light_color = init_fog_color
    environment.environment.fog_light_energy = init_fog_light_energy
    environment.environment.fog_density = init_fog_density
    
func _on_cleanse(wave_number: int, final_wave: bool):
    light.light_energy = cleansed_directional_energy
    light.light_color = cleansed_directional_color
    light.rotation = cleansed_directional_rotation
    
    environment.environment.background_energy_multiplier = cleansed_sky_energy
    environment.environment.ambient_light_energy = cleansed_ambient_light_energy
    environment.environment.fog_light_color = cleansed_fog_color
    environment.environment.fog_light_energy = cleansed_fog_light_energy
    environment.environment.fog_density = cleansed_fog_density
