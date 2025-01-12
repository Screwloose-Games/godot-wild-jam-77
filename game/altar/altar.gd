extends Node3D

class_name Altar

signal activated
signal purified
signal level_updated(float)


@export var assigned_enemies: Array[Enemy] = []
@export var altar_power: String = ""
@export var checkpoint: Node = null

var is_active: bool = false
var is_purified: bool = false


var total_area_enemies : int = 0
var current_area_enemies : int = 0
var spawned_enemies: Array[Node] = []
var purifaction_progress : float :
    set(value):
        purifaction_progress = clamp(value,0,1)
var purify_list = [] # list of purfiable objects

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
        total_area_enemies += 1

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


func _on_enemydetect_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
    if area == null:
        purifaction_progress = 1 - total_area_enemies / current_area_enemies
    current_area_enemies -= 1
    current_area_enemies = clamp(current_area_enemies,0,total_area_enemies)


func _on_enemydetect_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
    current_area_enemies += 1
    current_area_enemies = clamp(current_area_enemies,0,total_area_enemies)




func _on_border_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
   if area.is_in_group("Morphable"):
    purify_list.append(area.get_parent())
