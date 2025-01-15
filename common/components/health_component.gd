## Tracks and handles health for anything that has health
extends Node

signal health_max_updated(max_health: int)
signal health_updated(current_health: int)
signal damaged(amount: int)
signal healed(amount: float)
signal health_low
signal died

@export var max_health: float = 100
@export var is_dead := false

var min_health = 0
@onready
var current_health: float = max_health:
  set(val):
    current_health = val
    health_updated.emit(current_health)
    if current_health == 0 and not is_dead:
      die()

var missing_health: float:
  get:
    return max_health - current_health

func _ready() -> void:
  await get_tree().create_timer(0).timeout
  health_max_updated.emit(max_health)
  health_updated.emit(current_health)

func die():
  is_dead = true
  died.emit()

func damage(amount: int):
  damaged.emit(amount)
  var new_health = current_health - amount 
  current_health = max(0, new_health)

func heal(amount: float):
  healed.emit(amount)
  var new_health = current_health + amount 
  current_health = min(max_health, new_health)
