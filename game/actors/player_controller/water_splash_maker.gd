class_name WaterSplashMaker
extends Node3D

@onready var mob: CharacterBody3D = $".."
@onready var detect_water_raycast: RayCast3D = $DetectWaterRaycast

const WATER_SPLASH = preload("res://game/special_effects/water_splash.tscn")
const WATER_RIPPLE = preload("res://game/special_effects/water_ripple.tscn")

func _ready():
    # Detect water shader area3d
    detect_water_raycast.collide_with_areas = true
    detect_water_raycast.hit_from_inside = true
    detect_water_raycast.add_exception(mob)


func try_making_water_splash():
    #if mob.is_on_floor():
    if detect_water_raycast.is_colliding():
        var hit_floor = detect_water_raycast.get_collider()
        #print("Water splash hit ", hit_floor)
        if hit_floor is WaterSplashArea:
            create_water_splash()


func create_water_splash():
    #print("Water splash")
    var water_splash: Node3D = WATER_SPLASH.instantiate()
    get_tree().root.add_child(water_splash)
    water_splash.global_position = mob.global_position
    
    var water_ripple: Node3D = WATER_RIPPLE.instantiate()
    get_tree().root.add_child(water_ripple)
    water_ripple.global_position = detect_water_raycast.get_collision_point() + Vector3.UP * 0.1
    water_ripple.global_rotation = Vector3(0, randf_range(deg_to_rad(0), deg_to_rad(360)), 0)
    
