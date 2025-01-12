extends Node3D

class_name Altar

signal activated
signal purified

@export var assigned_enemies: Array[Enemy] = []
@export var altar_power: String = ""
@export var checkpoint: Node = null

var is_active: bool = false
var is_purified: bool = false

var spawned_enemies: Array[Node] = []

# Activate the altar
func activate(player: PlayerController):
    if is_active or is_purified:
        return
    is_active = true
    emit_signal("activated")

    # Link checkpoint activation
    if checkpoint:
        checkpoint.call("activate")

    # Grant power to the player
    grant_power(player)
    
    # Spawn enemies
    spawn_enemies()

## Spawn enemies associated with the altar
func spawn_enemies():
    for enemy in assigned_enemies:
        enemy.activate()

## Reset enemies
func reset_enemies():
    for enemy in spawned_enemies:
        enemy.reset()

func reset():
    reset_enemies()
    remove_power()

## Removes the power from the player
func remove_power():
    pass

## Grant power to the player
func grant_power(player: PlayerController):
    pass

func _on_interactable_area_3d_interacted(player: PlayerController) -> void:
    activate(player)
