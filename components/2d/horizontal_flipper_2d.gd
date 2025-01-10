## As a node in a CharacterBody2D scene, will translate itself flipped left and
## right according to the movement direction of the CharacterBody2D scene root. 
extends Node2D
class_name HorizontalFlipper2D

## The `global_transform.x.x` when the CharacterBody2D is facing right.
const FACING_RIGHT_TRANSFORM: int = 1

@onready var translation_base: CharacterBody2D = owner

func _ready() -> void:
    if translation_base is not CharacterBody2D:
        push_error("Scene root must be a `CharacterBody2D`")

func _process(delta):
    if is_moving_left():
        _face_left()
    elif is_moving_right():
        _face_right()

func is_moving_left():
    return translation_base.velocity.x < 0

func is_moving_right():
    return translation_base.velocity.x > 0

func _is_facing_left():
    return global_transform.x.x == -FACING_RIGHT_TRANSFORM

func _face_left():
    global_transform.x.x = -FACING_RIGHT_TRANSFORM

func _face_right():
    global_transform.x.x = FACING_RIGHT_TRANSFORM
