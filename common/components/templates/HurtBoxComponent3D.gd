@tool
extends ComponentArea3D
class_name HurtBoxComponent3D

## This Hurtbox is the Area3D that a hitbox hits and applies damage to
## "I have taken damage through my hurtbox, and was hit by a hitbox"

signal hurt(hit_box, amount)

## the owner of the hurt box
@export var reciever: Node3D
## the amount of time before hurt can be applied again
@export var cooldown: float

var cooldown_left: float = 0.0

func is_hurt_on_cooldown() -> bool:
    if cooldown_left <= 0.0: return false;
    return true

func apply_hurt(sender: Node3D, amount: float) -> void:
    if is_hurt_on_cooldown(): return
    hurt.emit(sender, amount)
    prints(sender, "applied hurt for", amount)

func decrement_hurt_cooldown_left(delta) -> void:
    if cooldown_left > 0.0: cooldown_left -= delta;

func reset_hurt_cooldown_left() -> void:
    cooldown_left = cooldown

func _physics_process(delta):
    decrement_hurt_cooldown_left(delta)    
