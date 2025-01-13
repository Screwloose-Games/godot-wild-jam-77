extends Node3D


@export var hitting_color: Color
@export var default_color: Color


@onready var visual: CSGBox3D = $Visual

var can_attack: bool = true

@onready var root: Enemy = $".."

@onready var hit_box_component_3d: HitBoxComponent3D = %HitBoxComponent3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    visual.material.albedo_color = default_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    return
    if can_attack:
        attack()

func start_cooldown():
    await get_tree().create_timer(root.attack_cooldown).timeout
    can_attack = true

func attack():
    can_attack = false
    visual.material.albedo_color = hitting_color
    hit_box_component_3d.activate()
    start_cooldown()
    await get_tree().create_timer(0.1).timeout
    
    visual.material.albedo_color = default_color
    
