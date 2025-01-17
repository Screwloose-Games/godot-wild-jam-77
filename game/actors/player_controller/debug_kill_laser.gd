extends Node3D

## Test laser for killing things instantly

const LASER_ENABLED: bool = false

@onready var ray_cast_3d = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
    if LASER_ENABLED:
        visible = true
    pass # Replace with function body.


func _physics_process(delta):
    if not LASER_ENABLED:
        return
    
    if Input.is_action_just_pressed("attack-ranged"):
        print("Shooting laser")
        if ray_cast_3d.is_colliding():
            var hit_obj = ray_cast_3d.get_collider()
            if hit_obj is Actor3D:
                hit_obj.health_component.die()
                print("Killed enemy: ", hit_obj)
