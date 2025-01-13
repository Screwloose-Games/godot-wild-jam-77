class_name Enemy
extends Actor3D

signal activated

@export var damage_amount: int = 25
@export_range(1, 5) var attack_range: float = 4

# Delay between when the spawner starts and when this entity should be spawned/activated
@export var delay_after_spawning_secs: int = 2
@export_range(0, 6) var attack_cooldown: float = 2.0

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D


# On spawned by wave, activate this entity
func activate():
    activated.emit()

func move(p_velocity: Vector3) -> void:
    velocity = lerp(velocity, p_velocity, 0.2)
    move_and_slide()

func update_facing() -> void:
    face_dir(velocity)

## Face specified direction.
func face_dir(dir: Vector3) -> void:
    face_direction(dir)
    return
    if dir.length() > 0.01:  # Ensure the direction is significant enough to update
        var target_rotation = dir.normalized().angle_to(Vector3.FORWARD)
        # Align character's rotation in the direction of movement
        var y_rotation = Vector3.UP.rotated(Vector3(0, 1, 0), target_rotation)
        #root.rotation_degrees.y = y_rotation
