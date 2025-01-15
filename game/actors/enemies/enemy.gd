class_name Enemy
extends Actor3D

signal queued_for_activation
signal activated
signal deactivated

@export var damage_amount: int = 25
@export_range(0, 5) var attack_range: float = 0.5

# Delay between when the spawner starts and when this entity should be spawned/activated
@export_range(0, 120) var delay_after_spawning_secs: float = 0
#@export_range(0, 6) var attack_cooldown: float = 2.0

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D

@export var is_active: bool = false
    
@export var trigger_active: bool = false:
    set(val):
        if val and not is_active:
            _activate()
        trigger_active = false

func _ready():
    
    if is_active:
        _activate()
    else:
        _deactivate()

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity += get_gravity()

# On spawned by wave, activate this entity
func activate():
    if is_active:
        return
    queued_for_activation.emit()
    await get_tree().create_timer(delay_after_spawning_secs).timeout
    _activate()

func _activate():
    is_active = true
    activated.emit()
    process_mode = PROCESS_MODE_INHERIT

func _deactivate():
    process_mode = PROCESS_MODE_DISABLED

func deactivate():
    activated.emit()
    _deactivate()

func move(p_velocity: Vector3) -> void:
    velocity = lerp(velocity, p_velocity, 0.2)
    move_and_slide()

func update_facing() -> void:
    face_dir(velocity)

## Face specified direction.
func face_dir(dir: Vector3) -> void:
    face_direction(dir)
    return
    if dir.length() > 0.01:  # Ensure the direction is significant enough to update
        var target_rotation = dir.normalized().angle_to(Vector3.FORWARD)
        # Align character's rotation in the direction of movement
        var y_rotation = Vector3.UP.rotated(Vector3(0, 1, 0), target_rotation)
        #root.rotation_degrees.y = y_rotation

func _on_hurt_box_component_3d_hurt(hit_box: Variant, amount: Variant) -> void:
    print("Enemy hurt")
    health_component.damage(amount)

func _on_health_component_died() -> void:
    die()
