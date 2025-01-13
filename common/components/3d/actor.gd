class_name Actor3D
extends CharacterBody3D

signal died

@export var speed: int = 10
@export var faction: Factions = Factions.FACTION_ENEMY
@export var max_health: int = 100
@export_range(0.5, 5) var turning_speed: float = 1

var last_direction := Vector3.MODEL_FRONT

enum Factions {
    FACTION_ENEMY,
    FACTION_PLAYER
}


func face_toward(target_positon: Vector3):
    # Calculate the direction to the target
    var direction: Vector3 = (target_positon - global_transform.origin)
    face_direction(direction)

func face_direction(direction: Vector3):
    direction.y = 0  # Ignore the Y-axis to only rotate around Y
    direction = direction.normalized()

    # Calculate the desired rotation in radians
    var desired_rotation: float = atan2(direction.x, direction.z)

    # Apply the rotation
    rotation.y = desired_rotation

func rotation_to_direction(direction: Vector3):
    direction.y = 0  # Ignore the Y-axis to only rotate around Y
    direction = direction.normalized()
    return atan2(direction.x, direction.z)

func face_dir_lerp(direction: Vector3, delta: float) -> void:
    # Calculate the direction to the target
    

    # Calculate the desired rotation in radians
    var desired_rotation: float = rotation_to_direction(direction)

    # Interpolate the current rotation toward the desired rotation
    var new_rotation_y: float = lerp_angle(rotation.y, desired_rotation, turning_speed * delta)
    #var new_rotation_y: float = desired_rotation

    # Apply the interpolated rotation
    rotation.y = new_rotation_y

func die():
    died.emit()
    queue_free.call_deferred()
