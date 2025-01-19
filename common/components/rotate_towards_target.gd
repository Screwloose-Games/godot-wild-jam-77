class_name RotateTowardsTarget
extends Node

@onready var mob: Node3D = $"../.."
@export var lerp_speed: float = 8.0

func apply_rotate(target: Node3D, delta: float):
    if target == null:
        return
    
    if mob is CharacterBody3D:
        var direction_to_target: Vector3 = mob.global_position.direction_to(target.global_position)
        mob.rotation.y = lerp_angle(mob.rotation.y, atan2(-direction_to_target.x, -direction_to_target.z), delta * lerp_speed)
