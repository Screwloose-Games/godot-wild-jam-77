class_name DetectEntities
extends Node

## Detect Entities

signal player_detected(player_entity: Node3D)
signal enemy_detected(enemy_entity: Node3D)

# Area3d for searching for entities in
@export var detection_area: Area3D


func scan_for_entities():
    if detection_area == null:
        push_warning("Missing detection area!")
        return
    
    # Scan through everything inside of the detection area
    # Emit signals to notify the controller
    for body in detection_area.get_overlapping_bodies():
        if body is CharacterBody3D:
            if body is BaseEntity:
                # Do something when you see an enemy
                if body.faction == BaseEntity.Factions.FACTION_ENEMY:
                    enemy_detected.emit(body)
                # Do something when you see a player
                elif body.faction == BaseEntity.Factions.FACTION_PLAYER:
                    player_detected.emit(body)
                continue
            pass
    pass
