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

##Transition
@export var transition_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    ##_on_new_area()
    GlobalSignalBus.changed_level.connect(_on_new_area)
    GlobalSignalBus.altar_succeeded.connect(_on_cleanse)
    ##await get_tree().create_timer(3.0).timeout
    ##_on_cleanse(0, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_new_area():
    light.light_energy = init_directional_energy
    light.light_color = init_directional_color
    light.rotation_degrees = init_directional_rotation
    
    environment.environment.background_energy_multiplier = init_sky_energy
    environment.environment.ambient_light_energy = init_ambient_light_energy
    environment.environment.fog_light_color = init_fog_color
    environment.environment.fog_light_energy = init_fog_light_energy
    environment.environment.fog_density = init_fog_density
    
func _on_cleanse():
    var tween = get_tree().create_tween()
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.set_parallel(true)
    tween.tween_property(light, "light_energy", cleansed_directional_energy, transition_time)
    tween.tween_property(light, "light_energy", cleansed_directional_color, transition_time)
    tween.tween_property(light, "rotation_degrees", cleansed_directional_rotation, transition_time)
    ##light.light_energy = cleansed_directional_energy
    ##light.light_color = cleansed_directional_color
    ##light.rotation = cleansed_directional_rotation
    tween.tween_property(environment.environment, "background_energy_multiplier", cleansed_sky_energy, transition_time)
    tween.tween_property(environment.environment, "ambient_light_energy", cleansed_ambient_light_energy, transition_time)
    tween.tween_property(environment.environment, "fog_light_color", cleansed_fog_color, transition_time)
    tween.tween_property(environment.environment, "fog_light_energy", cleansed_fog_color, transition_time)
    tween.tween_property(environment.environment, "fog_density", cleansed_fog_density, transition_time)
    ##environment.environment.background_energy_multiplier = cleansed_sky_energy
    ##environment.environment.ambient_light_energy = cleansed_ambient_light_energy
    ##environment.environment.fog_light_color = cleansed_fog_color
    ##environment.environment.fog_light_energy = cleansed_fog_light_energy
    ##environment.environment.fog_density = cleansed_fog_density
