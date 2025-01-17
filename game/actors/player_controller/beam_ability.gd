@tool
extends Node3D

class_name BeamAbility

var max_beam_range: float
@export_range(0, 10) var beam_start_delay: float
@export_range(0, 10) var beam_stop_delay: float

@onready var visual: CSGBox3D = $BeamVisual
@onready var collisionShape: CollisionShape3D = %BeamCollisionShape3D
@onready var hit_box_component_3d: HitBoxComponent3D = %BeamHitBox3D
@onready var raycast: RayCast3D = %RayCast3D

var isHoldingBeamAttack: bool
    
func _process(delta):
    if raycast.is_colliding() and isHoldingBeamAttack:
        if !raycast.get_collider().is_in_group("Enemy"):
            #hit something thats not an enemy, reshape hit box to end
            # here.
            set_beam_size(raycast.get_collider().global_position.distance_to(global_position))
        else:
            set_beam_size(max_beam_range)
            print("AJ RESET BEAM!")
    elif !raycast.is_colliding() and isHoldingBeamAttack:
        set_beam_size(max_beam_range)
            
func init_beam_size():
    raycast.target_position = Vector3(0, 0, -max_beam_range)
    set_beam_size(max_beam_range)
    
func set_beam_size(size: float):
    visual.size.z = size
    visual.position.z = -(size / 2)
    collisionShape.shape.size = Vector3(1, 1, size)
    collisionShape.position.z = -(size / 2)
    raycast.target_position = Vector3(0, 0, -max_beam_range)

func attack():
    if isHoldingBeamAttack:
        return
    
    await get_tree().create_timer(beam_start_delay).timeout
    raycast.enabled = true
    isHoldingBeamAttack = true
    visual.visible = true
    hit_box_component_3d.activate()
    
func stopAttack():
    await get_tree().create_timer(beam_stop_delay).timeout
    raycast.enabled = false
    isHoldingBeamAttack = false
    visual.visible = false
    hit_box_component_3d.deactivate()
