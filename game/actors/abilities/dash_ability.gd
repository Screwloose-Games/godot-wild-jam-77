extends Node
class_name DashAbility

@export var distance: float = 30.0
@export var duration: float = 0.5

@onready var actor: Actor3D = owner

signal started_dashing
signal stopped_dashing

var is_dashing: bool = false
var _dash_timer: Timer
var _original_velocity: Vector3
var dash_speed: float = distance / duration

func _ready():
    # Ensure a Timer exists to track dash duration
    _dash_timer = Timer.new()
    
    _dash_timer.one_shot = true
    _dash_timer.timeout.connect(_on_dash_finished)
    add_child(_dash_timer)


func set_velocity():
    # Calculate dash velocity
    var direction = actor.input_direction  # Assuming forward direction is along X-axis
    var dash_velocity = direction * dash_speed
    actor.velocity = dash_velocity
    actor.move_and_slide()

func dash():
    if is_dashing:
        set_velocity()
        return  # Prevent dashing again if already dashing

    

    # Store original velocity and set dash velocity
    _original_velocity = actor.velocity
    
    set_velocity()

    # Emit signal and start dash timer
    emit_signal("started_dashing")
    is_dashing = true
    _dash_timer.start(duration)

func _on_dash_finished():
    # Reset velocity and emit signal
    actor.velocity = _original_velocity
    emit_signal("stopped_dashing")
    is_dashing = false
