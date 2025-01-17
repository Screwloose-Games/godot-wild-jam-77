extends Node3D

@onready var audio: AudioStreamPlayer3D = $audio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func start_hum():
    audio.play(0.0)
    
func stop_hum():
    audio.stop()
