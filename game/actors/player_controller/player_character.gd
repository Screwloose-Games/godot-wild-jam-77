@tool
extends Actor3D
class_name PlayerController

@export var jump_velocity = 4.5
@export var mouse_sensitivity: float = 0.05

@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360

@export_range(0, 10) var dash_distance: float = 5
@export_range(0, 0.5) var dash_duration: float = 0.25
@export_range(0, 6) var melee_attack_cooldown: float = 2:
    set(val):
        melee_attack_cooldown = val
        if not melee_ability: return
        melee_ability.attack_cooldown = val
    get:
        return melee_attack_cooldown

var input_direction: Vector3 = Vector3.FORWARD

@onready var _camera: Camera3D = %Camera3D

@onready var _player_pcam = %PlayerPhantomCamera3D

@onready var dash_ability: DashAbility = %DashAbility
@onready var melee_ability: MeleeAbilty = %MeleeAbility

func _ready():
    _init_child_values()
    if Engine.is_editor_hint():
        return
    if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _init_child_values():
    melee_ability.attack_cooldown = melee_attack_cooldown

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

func _physics_process(delta: float) -> void:
    if Engine.is_editor_hint():
        return
    if dash_ability.is_dashing:
        return
    if Input.is_action_just_pressed("attack-melee"):
        melee_ability.attack()
    if Input.is_action_just_pressed("dash"):
        if get_global_input_direction():
            dash_ability.dash(get_global_input_direction())
    
    if velocity.length() > 0.2:
        var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
        #_player_direction.rotation.y = look_direction.angle()
    
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir := Input.get_vector("left", "right", "forward", "back")
    var cam_dir: Vector3 = -_camera.global_transform.basis.z
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    face_direction(_camera.global_transform.basis.z)
    if direction:
        var move_dir: Vector3 = Vector3.ZERO
        move_dir.x = direction.x
        move_dir.z = direction.z
        input_direction = move_dir

        #move_dir = move_dir.rotated(Vector3.UP, _camera.rotation.y).normalized()
        velocity.x = move_dir.x * speed
        velocity.z = move_dir.z * speed
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

func die():
    died.emit()
    get_tree().reload_current_scene()

func _on_hurt_box_component_3d_hurt(hit_box: Variant, amount: Variant) -> void:
    print("Player hurt")
    health_component.damage(amount)

func _on_health_component_died() -> void:
    die()
