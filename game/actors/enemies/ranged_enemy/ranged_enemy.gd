@tool
extends Enemy
class_name RangedEnemy

@export_group("Telegraph")
@export var telegraph_duration: float
@export var telegraph_starting_radius: float
@export var telegraph_to_beam_delay: float
@export_group("Beam")
@export var beam_duration: float
@export var beam_radius: float

@onready var ranged_ability: RangedAbilty = %RangedAbility
@onready var animation_player: AnimationPlayer = $Visual/sk_ranged_enemy/AnimationPlayer
@onready var bt_player: BTPlayer = %BTPlayer
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D



var is_executing_attack_sequence: bool:
    get:
        return ranged_ability.is_executing_attack_sequence

func _ready() -> void:
    super._ready()
    animation_player.play("PlantLoverIdle")

func attack(target: Node3D):
    pass

func die():
    bt_player.active = false
    animation_player.play("MeleeEnemyDeath")
    super.die()
