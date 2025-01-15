@tool
extends Node3D

class_name BeamAbility

@export var max_beam_range: float
@export_range(0, 10) var beam_start_delay: float
@export_range(0, 10) var beam_stop_delay: float

@onready var visual: CSGBox3D = $BeamVisual
@onready var collisionShape: CollisionShape3D = %BeamCollisionShape3D
@onready var hit_box_component_3d: HitBoxComponent3D = %BeamHitBox3D

var isHoldingBeamAttack: bool

func _ready():
    visual.size.z = max_beam_range
    visual.position.z = -(max_beam_range / 2)
    collisionShape.shape.size = Vector3(1, 1, max_beam_range)
    collisionShape.position.z = -(max_beam_range / 2)

func attack():
    if isHoldingBeamAttack:
        return
        
    await get_tree().create_timer(beam_start_delay).timeout
    isHoldingBeamAttack = true
    visual.visible = true
    hit_box_component_3d.activate()
    
func stopAttack():
    await get_tree().create_timer(beam_stop_delay).timeout
    isHoldingBeamAttack = false
    visual.visible = false
    hit_box_component_3d.deactivate()
