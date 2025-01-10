## Shows the area that the weapon/entity can "hit"
class_name HitBox3D
extends Area2D

signal hit(target: Area3D)

func hit_target(target: HurtBox2D, damage: int):
    target.receive_hit(damage)
    hit.emit(target)
