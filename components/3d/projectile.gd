extends Node2D

class_name Projectile3D

@export var fire_sound_name: StringName
@export var speed: float = 200.0
@export var team: TeamUtils.Team
@export var explode_on_contact = false
@onready var hit_box_component: HitBox2D = $HitBox2D

var target: Node2D
var is_returning_to_sender: bool = false
var boomerang_mode: bool = false
var boomerang_catch_distance: float = 1
var range: float
var distance_travelled: float = 0.0

var velocity: Vector2 = Vector2(0, 0)

signal fired

func _ready():
    hit_box_component.hit.connect(_on_hit)
    hit_box_component.monitoring = false

func _init(direction: Vector2=Vector2.ZERO):
    set_velocity_from_direction(direction)

#func configure(init_team: TeamUtils.Team):
    #team = init_team

func set_velocity_from_direction(direction: Vector2):
    velocity = direction * speed

func fire():
    visible = true
    hit_box_component.monitoring = true

func _on_hit(area: Area2D):
    if explode_on_contact:
        queue_free.call_deferred()
    if !boomerang_mode:
        queue_free.call_deferred()

func set_target(new_target: Node2D):
    target = new_target
    is_returning_to_sender = true

func _process(delta):
    if is_returning_to_sender:
        var direction_to_target = global_position.direction_to(target.global_position)
        global_position += speed * direction_to_target * delta
        if global_position.distance_to(target.global_position) <= boomerang_catch_distance:
            queue_free.call_deferred()
    else:
        var translation = velocity * delta
        global_position += translation
        distance_travelled += translation.length()
        if boomerang_mode and range and distance_travelled >= range:
            var target = get_tree().get_first_node_in_group("Player")
            set_target(target)
