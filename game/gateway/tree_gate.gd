extends Node3D

@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D
@onready var animation_player = $AnimationPlayer
@onready var gate_sfx: AudioStreamPlayer3D = $gate_sfx

@export var altar: Altar


func _ready():
    if altar:
        altar.purified.connect(on_altar_purified)
    else:
        push_warning("Tree gate missing altar")
    pass


func on_altar_purified():
    collision_shape_3d.set_deferred("disabled", true)
    animation_player.play("Gate1Open")
    gate_sfx.open_gate()
