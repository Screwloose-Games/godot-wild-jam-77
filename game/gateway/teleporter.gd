extends Area3D

signal interacted

@export var destination_mark: Marker3D
@export var static_image: Texture2D
@export var pressed_image: Texture2D

@onready var sprite_3d: Sprite3D = %Sprite3D

var area_active: bool = false

func _ready():
    sprite_3d.visible = false
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)

func _unhandled_input(event):
    if area_active and event.is_action_pressed("interact"):
        var player = get_tree().get_first_node_in_group("Player")
        SceneTransitionManager.change_position_with_transition(player, destination_mark, SceneManager.FADE_TRANSITION)
        get_viewport().set_input_as_handled()
        interacted.emit()

func _on_area_entered(area: Area3D) -> void:
    area_active = true
    sprite_3d.visible = true

func _on_area_exited(area: Area3D) -> void:
    area_active = false
    sprite_3d.visible = false
