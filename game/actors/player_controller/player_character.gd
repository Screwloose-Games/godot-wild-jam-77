@tool
extends Actor3D
class_name PlayerController

@export var jump_velocity = 4.5
@export var mouse_sensitivity: float = 0.05

@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360

## The degree to which the player can control their movement in the air compared to when they are on the ground.
@export_range(0, 1) var airborn_movement_factor: float = 0.5

@export_range(0, 10) var dash_distance: float = 5
@export_range(0, 0.5) var dash_duration: float = 0.25
@export_range(1, 2) var jumps_allowed: int = 2
@export_range(0, 6) var melee_attack_cooldown: float = 2:
    set(val):
        melee_attack_cooldown = val
        if not melee_ability: return
        melee_ability.attack_cooldown = val
    get:
        return melee_attack_cooldown
@export_group("Beam")
#@export_range(0, 10) var beam_tick_rate: float = 1:
    #set(val):
        #beam_tick_rate = val
        #if not beam_ability: return
        #beam_ability.beam_tick_rate = val
    #get:
        #return beam_tick_rate
@export_range(1, 50) var beam_damage: float = 5:
    set(val):
        beam_damage = val
        if not beam_hit_box_3d:
            await ready
        beam_hit_box_3d.amount = val
@export_range(1, 200) var max_beam_range: float = 100
@export_range(0, 10) var beam_speed_slowdown: float = 3

        
@export_range(0, 10) var beam_attack_start_delay: float = 1:
    set(val):
        beam_attack_start_delay = val
        if not beam_ability: return
        beam_ability.beam_attack_start_delay = val
    get:
        return beam_attack_start_delay
        
@export_range(0, 10) var beam_attack_stop_delay: float = 1:
    set(val):
        beam_attack_stop_delay = val
        if not beam_ability: return
        beam_ability.beam_attack_stop_delay = val
    get:
        return beam_attack_stop_delay

@export_group("Abilities")
@export var hasMeleeAbility: bool:
    set(val):
        hasMeleeAbility = val
        if not bone_attachment_3d:
            await ready
        bone_attachment_3d.visible = hasMeleeAbility
@export var hasRangedAbility: bool
@export var hasShieldAbility: bool

var input_direction: Vector3 = Vector3.FORWARD
var jumps_remaining := jumps_allowed

@onready var beam_hit_box_3d: HitBoxComponent3D = %BeamHitBox3D

@onready var _camera: Camera3D = %Camera3D
@onready var center_mass: Marker3D = %CenterMass
@onready var _player_pcam = %PlayerPhantomCamera3D

@onready var dash_ability: DashAbility = %DashAbility
@onready var melee_ability: MeleeAbilty = %MeleeAbility
@onready var beam_ability: BeamAbility = %BeamAbility
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var health_bar: ProgressBar = %HealthBar
@onready var bone_attachment_3d: BoneAttachment3D = %BoneAttachment3D
@onready var noclip: Noclip = $Noclip

@onready var player_sfx: Node3D = $player_sfx
var was_on_ground: bool = true

func _ready():
    _init_child_values()
    if Engine.is_editor_hint():
        return
    if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    initialize()

func initialize():
    hasMeleeAbility = hasMeleeAbility
    beam_ability = beam_ability

func _init_child_values():
    melee_ability.attack_cooldown = melee_attack_cooldown
    beam_ability.beam_start_delay = beam_attack_start_delay
    beam_ability.beam_stop_delay = beam_attack_stop_delay
    beam_ability.max_beam_range = max_beam_range
    beam_ability.set_beam_size(max_beam_range)

func get_global_input_direction():
    var input_dir := Input.get_vector("left", "right", "forward", "back")
    var cam_dir: Vector3 = -_camera.global_transform.basis.z
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    #var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        var move_dir: Vector3 = Vector3.ZERO
        move_dir.x = direction.x
        move_dir.z = direction.z
        #return move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
        return move_dir
    return Vector3.ZERO

func gauge_movement_speed() -> Vector2:
    if velocity.length() == 0 or speed == 0:
        return Vector2.ZERO

    # Get the forward direction in the x-z plane
    var forward_direction = transform.basis.z
    var relative_velocity = get_relative_velocity()
    #print(transform.basis.z)
    #print(relative_velocity)
    var normalized_forward = Vector2(forward_direction.x, forward_direction.z).normalized()

    # Calculate the speed ratio
    var speed_ratio = velocity.length() / speed

    # Get the movement direction relative to the character's facing direction
    var movement_direction = Vector2(velocity.x, velocity.z).normalized()
    var relative_movement = movement_direction.rotated(-normalized_forward.angle())

    return relative_movement * speed_ratio

func get_relative_velocity() -> Vector3:
    var forward_direction = transform.basis.z.normalized()
    var relative_velocity = velocity.project(forward_direction)
    return relative_velocity

func _handle_movement_animation():
    var mov = get_relative_velocity()
    var mov2 = Vector2(mov.z, mov.x)
    var forward_velocity = -velocity.dot(global_transform.basis.z)
    var side_velocity = velocity.dot(global_transform.basis.x)
    var char_velocity = Vector2(side_velocity, forward_velocity)
    char_velocity = char_velocity / speed
    #print(mov)
    animation_tree.set("parameters/run_direction/blend_position", char_velocity)

func can_jump():
    return jumps_remaining > 0

func _handle_jump():
    velocity.y = jump_velocity
    if not is_on_floor():
        jumps_remaining -= 1
        player_sfx._on_double_jump()
    else:
        player_sfx._on_jump()

func _physics_process(delta: float) -> void:
    _handle_movement_animation()
    if Engine.is_editor_hint():
        return
    if dash_ability.is_dashing:
        return
    if Input.is_action_just_pressed("attack-melee") and hasMeleeAbility:
        melee_ability.attack()
    if Input.is_action_just_pressed("attack-ranged") and hasRangedAbility:
        beam_ability.attack()
    if Input.is_action_just_released("attack-ranged") and hasRangedAbility:
        beam_ability.stopAttack()
    if Input.is_action_just_pressed("dash"):
        if get_global_input_direction():
            dash_ability.dash(get_global_input_direction())
    
    if velocity.length() > 0.2:
        var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
        #_player_direction.rotation.y = look_direction.angle()
    
    var input_dir := Input.get_vector("left", "right", "forward", "back")
    # Add the gravity.
    if not is_on_floor():
        was_on_ground = false
        input_dir = input_dir * airborn_movement_factor
        velocity += get_gravity() * delta
    else:
        if not was_on_ground:
            player_sfx.land_footstep()
            was_on_ground = true
            
        jumps_remaining = jumps_allowed

    # Handle jump.
    if Input.is_action_just_pressed("jump") and can_jump():
        _handle_jump()

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var cam_dir: Vector3 = -_camera.global_transform.basis.z
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))

    face_direction(_camera.global_transform.basis.z)
    
    #if noclip.is_noclip:
        #noclip.handle_noclip(Vector2(-direction.x, -direction.z))
        #return
    
    if direction:
        var move_dir: Vector3 = Vector3.ZERO
        move_dir.x = direction.x
        move_dir.z = direction.z
        input_direction = move_dir

        #move_dir = move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
        var beam_speed_penalty: float = 0
        if beam_ability.is_holding_beam_attack:
            beam_speed_penalty = beam_speed_slowdown
        velocity.x = move_dir.x * (speed - beam_speed_penalty)
        velocity.z = move_dir.z * (speed - beam_speed_penalty)
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
    _set_pcam_rotation(_player_pcam, event)

func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var pcam_rotation_degrees: Vector3

        # Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
        pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()

        # Change the X rotation
        pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity

        # Clamp the rotation in the X axis so it go over or under the target
        pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)

        # Change the Y rotation value
        pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity

        # Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
        pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)

        # Change the SpringArm3D node's rotation and rotate around its target
        pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)

func setAbility(abilityType: Altar.AbilityType, toSet: bool):
    match abilityType:
        Altar.AbilityType.MELEE:
            hasMeleeAbility = toSet
        Altar.AbilityType.RANGED:
            hasRangedAbility = toSet
        Altar.AbilityType.SHIELD:
            hasShieldAbility = toSet

func heal(amount: float):
    health_component.heal(amount)

func die():
    died.emit()
    GlobalSignalBus.player_died.emit()
    get_tree().reload_current_scene.call_deferred()

func _on_hurt_box_component_3d_hurt(hit_box: Variant, amount: Variant) -> void:
    print("Player hurt")
    health_component.damage(amount)

func _on_health_component_died() -> void:
    die()

func _on_health_component_health_changed(health: Variant) -> void:
    health_bar.value = health

func _on_max_health_updated(value: float) -> void:
    if not health_bar:
        await ready
    health_bar.max_value = value
