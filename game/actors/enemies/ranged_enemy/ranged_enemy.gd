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

var is_executing_attack_sequence: bool:
    get:
        return ranged_ability.is_executing_attack_sequence

func attack(target: Node3D):
    pass
