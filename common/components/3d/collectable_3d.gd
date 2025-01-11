@tool
extends Area3D
class_name Collectable3D

@export var texture: Texture2D:
    set = set_texture
@export var effects: Array[CollectableEffectResource]
@export var sound_effect_name: String = "energy_drink"
@onready var sprite_2d: Sprite2D = Sprite2D.new()
@onready var collision_shape: CollisionShape2D = CollisionShape2D.new()

func _ready():
    #set_collision_layer(8)
    add_child(sprite_2d)
    sprite_2d.texture = texture

func set_texture(new_texture: Texture2D):
    texture = new_texture
    if sprite_2d:
        sprite_2d.texture = texture

func get_collected(recipient: CharacterBody3D):
    for effect in effects:
        if effect.has_method("apply_effect"):
            effect.apply_effect(recipient)
    queue_free.call_deferred()
