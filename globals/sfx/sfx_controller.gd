extends Node

@export var pause_sound: AudioStream
@export var unpause_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignalBus.game_paused.connect(_start_pause)
    GlobalSignalBus.game_unpaused.connect(_end_pause)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _start_pause():
    SoundManager.play_ui_sound(pause_sound)
    
func _end_pause():
    SoundManager.play_ui_sound(unpause_sound)
