@tool
extends Node3D

class_name BeamAbility

var max_beam_range: float
@export_range(0, 10) var beam_start_delay: float
@export_range(0, 10) var beam_stop_delay: float
@export_range(0.1, 10) var beam_tick_rate: float = 2

@onready var visual: Node3D = $BeamVisual
@onready var collision_shape: CollisionShape3D = %BeamCollisionShape3D
@onready var hit_box_component_3d: HitBoxComponent3D = %BeamHitBox3D
@onready var raycast: RayCast3D = %RayCast3D
@onready var beam_cyl: CSGCylinder3D = %BeamCyl

@onready var _camera: Camera3D = %Camera3D
@onready var beam_ability: BeamAbility = %BeamAbility

var is_holding_beam_attack: bool

var beam_cooldown_remaining: float = 0
var tick_delay : float:
    get:
        return 1.0 / beam_tick_rate

@export_range(-90, 90) var beam_vertical_angle: float = 0

func _process(delta):
    if beam_cooldown_remaining > 0:
        beam_cooldown_remaining -= delta
    if beam_cooldown_remaining <= 0 and is_holding_beam_attack:
        _tick_hit()
    
    if Engine.is_editor_hint():
        return
    var val = deg_to_rad(beam_vertical_angle)
    visual.rotation.x = val
    beam_ability.rotation.x = _camera.rotation.x
    #visual.rotation.x = get_x_angle_rotation()
    
    if raycast.is_colliding() and is_holding_beam_attack:
        var collider = raycast.get_collider()
        if is_instance_valid(collider) and !collider.is_in_group("Enemy"):
            #hit something thats not an enemy, reshape hit box to end
            # here.
            set_beam_size(raycast.get_collider().global_position.distance_to(global_position))
        else:
            set_beam_size(max_beam_range)
    elif !raycast.is_colliding() and is_holding_beam_attack:
        set_beam_size(max_beam_range)
 
func get_x_angle_rotation() -> float:
    var direction = (raycast.target_position - raycast.position).normalized()
    var x_angle = atan2(direction.y, sqrt(direction.x * direction.x + direction.z * direction.z))
    return x_angle

func init_beam_size():
    raycast.target_position = Vector3(0, 0, -max_beam_range)
    set_beam_size(max_beam_range)
    
func set_beam_size(size: float):
    beam_cyl.height = size
    beam_cyl.position.z = -(size / 2)
    collision_shape.shape.size = Vector3(1, 1, size)
    collision_shape.position.z = -(size / 2)
    raycast.target_position = Vector3(0, 0, -max_beam_range)

func attack():
    if is_holding_beam_attack:
        return
    
    await get_tree().create_timer(beam_start_delay).timeout
    raycast.enabled = true
    is_holding_beam_attack = true
    visual.visible = true
    hit_box_component_3d.activate()
    get_parent().get_node("player_sfx")._on_beam_start()

func _tick_hit():
    print('tick hit"')
    hit_box_component_3d.activate()
    beam_cooldown_remaining = tick_delay
    get_parent().get_node("player_sfx")._on_beam_hit()

func stopAttack():
    await get_tree().create_timer(beam_stop_delay).timeout
    raycast.enabled = false
    is_holding_beam_attack = false
    visual.visible = false
    hit_box_component_3d.deactivate()
    get_parent().get_node("player_sfx")._on_beam_end()
