extends Node

@onready var gate_camera: PhantomCamera3D = %GateCamera
@onready var world_animation_player: AnimationPlayer = %WorldAnimationPlayer
@onready var tutorial_canvas_layer: TutorialCanvasLayer = %TutorialCanvasLayer
@onready var player_character: PlayerController = %PlayerCharacter

func _ready() -> void:
    pass
    tutorial_canvas_layer.hide()
    
    #PhantomCameraManager.
    #await gate_camera
    #gate_camera.priority = 10
    await tutorial_canvas_layer.ready
    tutorial_canvas_layer.next()
    world_animation_player.play("dark magic corrupted the land")
    await tutorial_canvas_layer.continued
    #await world_animation_player.animation_finished
    world_animation_player.play("gateway is locked")
    await tutorial_canvas_layer.continued
    #await world_animation_player.animation_finisheduse sacred altars
    world_animation_player.play("use sacred altars")
    await tutorial_canvas_layer.continued
    world_animation_player.play("destroy source of corruption")
    await tutorial_canvas_layer.continued
    player_character._player_pcam.priority = 30
    
    
    
