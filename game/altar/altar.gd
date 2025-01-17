extends Node3D

class_name Altar

signal activated
signal purified
signal purified_amount(amount_purified: float)

enum AbilityType { Melee, Ranged, Shield }

@export var assigned_enemies: Array[PackedScene] = []
@export var altar_power: String = ""
@export var max_altar_impact_scale: float = 50
@export var altar_ability: AbilityType

@onready var impact_unpure_environment_area: Area3D = $ImpactUnpureEnvironmentArea

var is_active: bool = false
var is_purified: bool = false

var spawned_enemies: Array[Node] = []
var total_spawned_enemies: int
var enemies_alive: int
var purity_ratio: float = 0
var scan_to_purify_timer: Timer = Timer.new()


func _ready():
    add_child(scan_to_purify_timer)
    scan_to_purify_timer.one_shot = false
    scan_to_purify_timer.wait_time = 0.5
    scan_to_purify_timer.timeout.connect(apply_purification)
    scan_to_purify_timer.start()
    pass


func _physics_process(delta: float):
    # Lerp the area based on purity ratio
    impact_unpure_environment_area.scale = lerp(impact_unpure_environment_area.scale, Vector3.ONE * purity_ratio * max_altar_impact_scale, 2 * delta)


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
    
    print("Altar: Altar activated")


## Spawn enemies associated with the altar
func spawn_enemies():
    for enemy_scene in assigned_enemies:
        var enemy: Node3D = load(enemy_scene.resource_path).instantiate()
        get_tree().root.add_child(enemy)
        enemy.global_position = global_position + Vector3.UP * 3
        if enemy is Enemy:
            enemy.activate()
            enemy.died.connect(on_enemy_died)
            total_spawned_enemies += 1
    enemies_alive = total_spawned_enemies
    print("Altar: Enemies alive: ", enemies_alive, " / total enemies: ", total_spawned_enemies)
    
    await get_tree().create_timer(5).timeout
    
    purity_ratio = 1
        

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
    purity_ratio = (total_spawned_enemies - enemies_alive) / clamp(total_spawned_enemies, 1, 100)
    print("Altar: purity amount: ", purity_ratio)
    purified_amount.emit(purity_ratio)


func apply_purification():
    for area in impact_unpure_environment_area.get_overlapping_areas():
        if area is PurificationSystem:
            if area.purification_progress < 1:
                area.purification_progress += 0.1
                area.purification_progress = clampf(area.purification_progress, 0.0, 1.0)
