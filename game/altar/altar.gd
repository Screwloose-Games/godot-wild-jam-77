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

    # Spawn enemies
    spawn_enemies()

    # Grant power to the player
    grant_power(player)

## Spawn enemies associated with the altar
func spawn_enemies():
    for enemy_scene in assigned_enemies:
        var enemy_instance = enemy_scene.instantiate()
        add_child(enemy_instance)
        spawned_enemies.append(enemy_instance)

## Reset enemies
func reset_enemies():
    for enemy in spawned_enemies:
        if is_instance_valid(enemy):
            enemy.queue_free()
    spawned_enemies.clear()

## Grant power to the player
func grant_power(player: PlayerController):
    if not player.has_method("add_power"):
        return

    if player.call("has_power", altar_power):
        return

    player.call("add_power", altar_power)


func _on_interactable_area_3d_interacted(player: PlayerController) -> void:
    activate(player)
