extends Node3D
class_name RangedAbilty

@export var hitting_color: Color
@export var default_color: Color
@export_range(0, 6) var attack_cooldown: float = 2
@export var beam_length: float = 10:
    set(val):
        telegraph_shape.height = val

@export var trigger_beam: bool = false:
    set(val):
        if val:
            attack()
    get:
        return false
        


@export var can_attack: bool = true:
    set(val):
        can_attack = val

@onready var root: Actor3D = $".."

@onready var hit_box_component_3d: HitBoxComponent3D = %HitBoxComponent3D
@onready var telegraph_shape: CSGCylinder3D = %TelegraphShape
@onready var beam_start: Marker3D = %BeamStart
@onready var beam_ray: RayCast3D = %BeamRay
@onready var path_3d: Path3D = %Path3D
@onready var path_follow_3d: PathFollow3D = %PathFollow3D
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D



var telegraph_duration: float = 1
var telegraph_starting_radius: float = 0.01
var telegraph_to_beam_delay: float = 0.5

var beam_duration: float = 0.2
var beam_radius: float = 0.1


var cooldown_remaining: float = 0

var distance_to_target: float = 0
var direction_to_target: Vector3 = Vector3.ZERO

var is_executing_attack_sequence: bool = false

var extend_beam_distance: float = 100

var beam_extension_length: float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    telegraph_shape.material.albedo_color = default_color
    beam_start.visible = false

func _update_path():
    path_3d.curve.remove_point(1)
    #path_3d.curve.add_point()
    #path_end.positon = direction_to_target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    if cooldown_remaining > 0:
        cooldown_remaining -= delta
    if cooldown_remaining <= 0 and not can_attack:
        _on_attack_cooldown_ended()
    if is_executing_attack_sequence:
        return
    var player: PlayerController = get_tree().get_first_node_in_group("Player")
    if player:
        direction_to_target = player.global_position - global_position
        distance_to_target = direction_to_target.length()
        #beam_ray.target_position = beam_ray.to_local(player.center_mass.global_position)
        beam_ray.target_position.z = beam_ray.to_local(player.global_position).z
        var target_pos = beam_ray.to_local(player.center_mass.global_position)
        var vertical_beam_tracking_speed = 1
        beam_ray.target_position.y = lerp(beam_ray.target_position.y, target_pos.y, delta * vertical_beam_tracking_speed)
        #beam_ray.target_position = get_distance_point_from_direction(beam_ray.target_position)   
        #beam_ray.target_position = extend_ray(beam_ray.position, beam_ray.target_position, beam_extension_length)
        
        path_3d.curve.remove_point(1)
        path_3d.curve.add_point(beam_ray.target_position)
        
        telegraph_shape.height = beam_ray.target_position.length() * 2
        #return
        path_follow_3d.progress_ratio = 1
        #path_end.positon = direction_to_target

func extend_ray(start_point: Vector3, end_point: Vector3, extension_distance: float) -> Vector3:
    # Calculate the direction of the ray
    var direction = (end_point - start_point).normalized()
    # Extend the ray by adding the direction scaled by the extension distance
    return end_point + direction * extension_distance
         
func is_on_target():
    return beam_ray.get_collider() is HurtBoxComponent3D 

func should_attack():
    var on = is_on_target()
    return is_on_target() and can_attack

func start_cooldown() -> void:
    await get_tree().create_timer(attack_cooldown).timeout
    _on_attack_cooldown_ended()

func _on_attack_cooldown_ended():
    can_attack = true

func _on_attack_ended():
    telegraph_shape.material.albedo_color = default_color
    telegraph_shape.material.emission = default_color

func get_distance_point_from_direction(direction: Vector3):
    return direction * 10

func telegraph():
    can_attack = false
    is_executing_attack_sequence = true
    beam_start.visible = true
    telegraph_shape.radius = telegraph_starting_radius
    var tween = get_tree().create_tween()
    tween.tween_property(telegraph_shape, "radius", beam_radius, telegraph_duration)
    await tween.finished
    beam_start.visible = false
    await get_tree().create_timer(telegraph_to_beam_delay).timeout
    beam_start.visible = true
    attack()
    await get_tree().create_timer(beam_duration).timeout
    beam_start.visible = false
    is_executing_attack_sequence = false
    


func attack() -> void:
    cooldown_remaining = attack_cooldown
    if not can_attack:
        print("Cant attack")
        return
    can_attack = false
    telegraph_shape.material.albedo_color = hitting_color
    telegraph_shape.material.emission = hitting_color
    (collision_shape_3d.shape as CylinderShape3D).height = telegraph_shape.height
    (collision_shape_3d.shape as CylinderShape3D).radius = telegraph_shape.radius
    hit_box_component_3d.global_transform = telegraph_shape.global_transform
    hit_box_component_3d.activate()
    await get_tree().create_timer(0.05).timeout
    hit_box_component_3d.deactivate()
    start_cooldown()
    await get_tree().create_timer(0.1).timeout
    
    
    
