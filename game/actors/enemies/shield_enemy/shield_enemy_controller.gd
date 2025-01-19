extends Node

enum ShieldStates
{
    STATE_IDLE,
    STATE_CHARGE,
}

@onready var mob: Enemy = $".."

@onready var health_component: HealthComponent = %HealthComponent
@onready var hit_box_component_3d: HitBoxComponent3D = $"../HitBoxComponent3D"
@onready var gravity: Gravity = $Gravity
@onready var detection_area: Area3D = $"../DetectionArea"
@onready var stop_charging_cast: RayCast3D = $"../StopChargingCast"
@onready var rotate_towards_motion: RotateTowardsMotion = $RotateTowardsMotion
@onready var rotate_towards_target: RotateTowardsTarget = $RotateTowardsTarget
@onready var charge_timeout: Timer = $ChargeTimeout
@onready var anim_player: AnimationPlayer = $"../sk_shield_enemy/AnimationPlayer"
@onready var skulls_anim_player: AnimationPlayer = $"../sk_shield_enemy/SkullsOrbiting/SkullsAnimPlayer"

@export var charge_speed: float = 5

var combat_target: Node3D
var state: ShieldStates = ShieldStates.STATE_IDLE : set = enter_state
var charge_direction: Vector3
var charge_timer: Timer = Timer.new()
var scan_target_timer: Timer = Timer.new()


func _ready():
    mob.dont_do_phys_process = true
    mob.activated.connect(on_activated)
    mob.is_active = true
    mob.queue_free_on_death = false
    mob.activate()
    #on_activated()
    
    add_child(charge_timer)
    charge_timer.wait_time = 1
    charge_timer.one_shot = true
    charge_timer.timeout.connect(on_charge_time)
    charge_timer.start()
    
    add_child(scan_target_timer)
    scan_target_timer.wait_time = 2
    scan_target_timer.one_shot = true
    scan_target_timer.start()
    
    charge_timeout.timeout.connect(on_charge_timeout)
    charge_timeout.one_shot = true
    
    health_component.died.connect(on_death)
    pass


func _physics_process(delta):
    if health_component.health <= 0 or not health_component.is_alive:
        mob.velocity = Vector3.ZERO
        if not mob.is_on_floor():
            gravity.apply_gravity(delta)
        mob.move_and_slide()
        return
    
    if combat_target:
        match state:
            ShieldStates.STATE_IDLE:
                mob.velocity = Vector3.ZERO
                rotate_towards_target.apply_rotate(combat_target, delta)
            ShieldStates.STATE_CHARGE:
                mob.velocity = charge_direction * charge_speed
                rotate_towards_motion.apply_rotate(delta)
        #print("Shield enemy in combat, at state: ", state)
    else:
        mob.velocity = Vector3.ZERO
        if scan_target_timer.is_stopped():
            scan_target_timer.start()
            detect_targets()
    
    if not mob.is_on_floor():
        gravity.apply_gravity(delta)
    
    mob.move_and_slide()
    
    if stop_charging_cast.is_colliding():
        if state == ShieldStates.STATE_CHARGE:
            #print("Hit wall stopping charging")
            await get_tree().create_timer(1).timeout
            state = ShieldStates.STATE_IDLE


func enter_state(new_state: ShieldStates):
    state = new_state
    print("Shield enemy state: ", state)
    match state:
        ShieldStates.STATE_IDLE:
            anim_player.play("FurballSitting")
            hit_box_component_3d.deactivate()
            charge_timer.start()
            pass
        ShieldStates.STATE_CHARGE:
            if combat_target != null:
                anim_player.play("FurballRun")
                hit_box_component_3d.activate()
                charge_direction = mob.global_position.direction_to(combat_target.global_position)
                #print("Charging in direction: ", charge_direction)
            else:
                state = ShieldStates.STATE_IDLE
            charge_timeout.start()
            pass


func on_charge_time():
    #print("Switch to charge time")
    state = ShieldStates.STATE_CHARGE


func on_charge_timeout():
    state = ShieldStates.STATE_IDLE


func on_activated():
    #print("Shield enemy activated")
    # Start by charging
    detect_targets()
    await get_tree().create_timer(1).timeout
    on_charge_time()
    charge_timer.start()


func detect_targets():
    for body in detection_area.get_overlapping_bodies():
        if body is PlayerController:
            combat_target = body
            return


func on_death():
    charge_timer.stop()
    charge_timeout.stop()
    anim_player.play("FurballDeath")
    skulls_anim_player.play("on_death")
    
    
