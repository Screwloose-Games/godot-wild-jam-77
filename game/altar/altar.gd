extends Node3D

class_name Altar

signal activated
signal purified
signal purified_amount(amount_purified: float)

@export var assigned_enemies: Array[PackedScene] = []
@export var altar_power: String = ""
@export var max_altar_impact_scale: float = 20 

@export var altar_ability: AbilityType
enum AbilityType { Melee, Ranged, Shield }

@onready var impact_unpure_environment_area: Area3D = $ImpactUnpureEnvironmentArea

var is_active: bool = false
var is_purified: bool = false

var spawned_enemies: Array[Node] = []
var total_spawned_enemies: int
var enemies_alive: int


func _ready():
    pass


## Used for assigning already spawned enemies to altar
func assign_enemy(enemy: Enemy):
    assigned_enemies.append(enemy)
    enemy.died.connect(on_enemy_died)
    total_spawned_enemies += 1


## Activate the altar
func activate(player: PlayerController):
    if is_active or is_purified:
        return
    is_active = true
    activated.emit()

    # Save that player has reached this checkpoint
    CheckpointMgr.arrived_at_altar(altar_power)
    
    # Grant power to the player
    grant_power(player)
    
    # Spawn enemies
    spawn_enemies()
    
    print("Altar activated")


## Spawn enemies associated with the altar
func spawn_enemies():
    for enemy_scene in assigned_enemies:
        var enemy = load(enemy_scene.resource_path).instantiate()
        if enemy is Enemy:
            enemy.activate()
            enemy.died.connect(on_enemy_died)
            total_spawned_enemies += 1
    enemies_alive = total_spawned_enemies
        

## Reset enemies
func reset_enemies():
    for enemy in spawned_enemies:
        enemy.reset()
        total_spawned_enemies = 0
        enemies_alive = 0


func reset(player: PlayerController):
    reset_enemies()
    remove_power(player)


## Removes the power from the player
func remove_power(player: PlayerController):
    player.setAbility(altar_ability, false)


## Grant power to the player
func grant_power(player: PlayerController):
    player.setAbility(altar_ability, true)


func _on_interactable_area_3d_interacted(player: PlayerController) -> void:
    activate(player)


## Call this function after the player purifies the altar and kills all the baddies
func purify_altar():
    purified.emit()
    CheckpointMgr.altar_completed(altar_power)


func on_enemy_died():
    var purity_amt: float = (total_spawned_enemies - enemies_alive) / clamp(total_spawned_enemies, 1, 100)
    print("purity amount: ", purity_amt)
    impact_unpure_environment_area.scale = lerp(impact_unpure_environment_area.scale, Vector3.ONE * purity_amt * max_altar_impact_scale, 2)
    purified_amount.emit(purity_amt)
