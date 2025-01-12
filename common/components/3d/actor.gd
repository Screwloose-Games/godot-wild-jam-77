class_name Actor3D
extends CharacterBody3D

signal died

@export var speed: int = 10
@export var faction: Factions = Factions.FACTION_ENEMY
@export var max_health: int = 100

enum Factions {
    FACTION_ENEMY,
    FACTION_PLAYER
}
