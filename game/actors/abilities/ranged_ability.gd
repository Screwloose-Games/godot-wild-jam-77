@tool
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
        


@export var can_attack: bool = true

@onready var root: Actor3D = $".."

@onready var hit_box_component_3d: HitBoxComponent3D = %HitBoxComponent3D
@onready var telegraph_shape: CSGCylinder3D = %TelegraphShape
@onready var beam_start: Marker3D = %BeamStart
@onready var beam_ray: RayCast3D = %BeamRay

var cooldown_remaining: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    telegraph_shape.material.albedo_color = default_color



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if cooldown_remaining > 0:
        cooldown_remaining -= delta
    if cooldown_remaining <= 0 and not can_attack:
        _on_attack_cooldown_ended()
    return
    if can_attack:
        attack()

func start_cooldown() -> void:
    await get_tree().create_timer(attack_cooldown).timeout
    _on_attack_cooldown_ended()

func _on_attack_cooldown_ended():
    can_attack = true

func _on_attack_ended():
    telegraph_shape.material.albedo_color = default_color
    telegraph_shape.material.emission = default_color

func attack() -> void:
    cooldown_remaining = attack_cooldown
    if not can_attack:
        print("Cant attack")
        return
    can_attack = false
    telegraph_shape.material.albedo_color = hitting_color
    telegraph_shape.material.emission = hitting_color
    hit_box_component_3d.activate()
    start_cooldown()
    await get_tree().create_timer(0.1).timeout
    
    
    
