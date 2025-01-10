## Shows the area in which the entity can be hurt
## Anything that can be hit must also have a `HealthComponent`
extends Area2D
class_name HurtBox3D

signal hurt(damage: int)

@onready var health_component: Health = %Health

func receive_hit(damage: int):
  hurt.emit(damage)
  health_component.take_damage(damage)
