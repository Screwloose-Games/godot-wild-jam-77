extends Node3D

class_name Altar

signal activated
signal purified
signal purified_amount(amount_purified: float)

enum AbilityType { MELEE, RANGED, SHIELD, NONE }

@export var assigned_enemies: Array[Enemy] = []
var altar_power: String = "":
    get:
        return str(altar_ability)
@export var max_altar_impact_scale: float = 50
@export var altar_ability: AbilityType

@onready var impact_unpure_environment_area: Area3D = $ImpactUnpureEnvironmentArea
@onready var interactable_area_3d: InteractableArea3D = %InteractableArea3D

var is_active: bool = false
var is_purified: bool = false

var spawned_enemies: Array[Node] = []
var total_spawned_enemies: int
var enemies_alive: int
var purity_ratio: float = 0.0:
    set(val):
        purity_ratio = val
var scan_to_purify_timer: Timer = Timer.new()

var player_who_activated: PlayerController

@onready var altar_sfx: Node3D = $AltarSFX

func _ready():
    GlobalSignalBus.player_died.connect(_on_death)
    add_child(scan_to_purify_timer)
    scan_to_purify_timer.one_shot = false
    scan_to_purify_timer.wait_time = 0.5
    scan_to_purify_timer.timeout.connect(apply_purification)
    scan_to_purify_timer.start()

func _physics_process(delta: float):
    # Lerp the area based on purity ratio
    impact_unpure_environment_area.scale = lerp(impact_unpure_environment_area.scale, Vector3.ONE * purity_ratio * max_altar_impact_scale, 2 * delta)


## Used for assigning already spawned enemies to altar
func assign_enemy(enemy: Enemy):
    if enemy in assigned_enemies:
        return
    print("Altar: Assigning enemy to altar: ", enemy)
    assigned_enemies.append(enemy)

## Activate the altar
func activate(player: PlayerController):
    if is_active or is_purified:
        return
    player_who_activated = player
    is_active = true
    GlobalSignalBus.altar_activated.emit()
    altar_sfx.start_hum()
    activated.emit()
    
    # Save that player has reached this checkpoint
    CheckpointMgr.arrived_at_altar(altar_power)
    
    if altar_ability != AbilityType.NONE:
        # Grant power to the player
        grant_power(player)
    
    # Spawn enemies
    spawn_enemies()
    
    enemies_alive = total_spawned_enemies
    
## Spawn enemies associated with the altar
func spawn_enemies():
    for enemy in assigned_enemies:
        # Handle if enemy dies before altar is activated
        if enemy == null:
            continue
        #var enemy: Node3D = load(enemy_scene.resource_path).instantiate()
        #get_tree().root.add_child(enemy)
        #enemy.global_position = global_position + Vector3.UP * 3
        if enemy is Enemy:
            enemy.activate()
            print("num")
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
    GlobalSignalBus.power_granted.emit(altar_ability)
    player.setAbility(altar_ability, true)


func _on_interactable_area_3d_interacted(player: PlayerController) -> void:
    activate(player)
    interactable_area_3d.disabled = true
    


## Call this function after the player purifies the altar and kills all the baddies
func purify_altar():
    purified.emit()
    GlobalSignalBus.altar_succeeded.emit()
    altar_sfx.stop_hum()
    CheckpointMgr.altar_completed(altar_power)


func on_enemy_died():
    enemies_alive -= 1
    if total_spawned_enemies == 0:
        return
    #var upper: float = total_spawned_enemies - enemies_alive
    print("alive: ", enemies_alive)
    purity_ratio = (total_spawned_enemies - enemies_alive) / float(total_spawned_enemies)
    print("Altar: sees enemy died, updating purity amount: ", str("%.2f" % purity_ratio), " from alive enemies: ", enemies_alive, " / ", total_spawned_enemies)
    purified_amount.emit(purity_ratio)
    
    if enemies_alive <= 0:
        purify_altar()
        heal_player()

func heal_player():
    player_who_activated.heal(100)

func apply_purification():
    for area in impact_unpure_environment_area.get_overlapping_areas():
        if area is PurificationSystem:
            if area.purification_progress < 1:
                area.purification_progress += 0.1
                area.purification_progress = clampf(area.purification_progress, 0.0, 1.0)

func _on_death():
    if is_active:
        GlobalSignalBus.altar_failed.emit()
        altar_sfx.stop_hum()
