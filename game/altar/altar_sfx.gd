extends Node3D

@export var hum_loop: AudioStream

@onready var audio: AudioStreamPlayer3D = $audio

func start_hum():
    audio.stream = hum_loop
    audio.play(0.0)
    
func stop_hum():
    audio.stop()
