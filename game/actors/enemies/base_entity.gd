class_name BaseEntity
extends Actor3D

## Base entity class with exportable variables

signal entity_activated

@export var damage_amount: int = 25
@export var movement_speed: float = 5

# Delay between when the spawner starts and when this entity should be spawned/activated
@export var delay_after_spawning_secs: int = 2


# On spawned by wave, activate this entity
func activate_entity():
    entity_activated.emit()
