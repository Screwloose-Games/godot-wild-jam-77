@tool
extends Node3D
class_name EnemyMeleeAbilty

@export var hitting_color: Color
@export var default_color: Color
@export_range(0, 6) var attack_cooldown: float = 2


@onready var visual: CSGBox3D = $Visual

var can_attack: bool = true

@onready var root: Actor3D = $".."

@onready var hit_box_component_3d: HitBoxComponent3D = %HitBoxComponent3D

enum AttackType {
    NONE,
    SLASHLR,
    SLASHRL
}

var attack_type: AttackType = AttackType.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    visual.material.albedo_color = default_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    return
    if can_attack:
        attack()

func start_cooldown():
    await get_tree().create_timer(attack_cooldown).timeout
    can_attack = true

func attack():
    if not can_attack:
        return
    can_attack = false
    _start_attack()
    #_handle_attack_animation()
    await get_tree().create_timer(0.1).timeout
    _end_attack()

func _start_attack():
    await get_tree().create_timer(0.1).timeout
    visual.material.albedo_color = hitting_color
    visual.material.emission = hitting_color
    hit_box_component_3d.activate()
    start_cooldown()
    
func _end_attack():
    visual.material.albedo_color = default_color
    visual.material.emission = default_color
