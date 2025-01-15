extends Node3D

class_name Altar

signal activated
signal purified

@export var assigned_enemies: Array[Enemy] = []
@export var altar_power: String = ""


var is_active: bool = false
var is_purified: bool = false

var spawned_enemies: Array[Node] = []


func _ready():
    pass

func assign_enemy(enemy: Enemy):
    assigned_enemies.append(enemy)

# Activate the altar
func activate(player: PlayerController):
    if is_active or is_purified:
        return
    is_active = true
    emit_signal("activated")

    # Save that player has reached this checkpoint
    CheckpointMgr.arrived_at_altar(altar_power)
    
    # Grant power to the player
    grant_power(player)
    
    # Spawn enemies
    spawn_enemies()


## Spawn enemies associated with the altar
func spawn_enemies():
    for enemy in assigned_enemies:
        if enemy is Enemy:
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


## Call this function after the player purifies the altar and kills all the baddies
func purify_altar():
    purified.emit()
    CheckpointMgr.altar_completed(altar_power)
