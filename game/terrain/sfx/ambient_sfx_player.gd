extends Node3D

@export var ambient_sound: AudioStream
@export var is_spatial: bool = false
@export var should_play_before_cleanse: bool = false

var audio_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if should_play_before_cleanse:     
        if is_spatial:
            audio_player = AudioStreamPlayer3D.new()
            add_child(audio_player)
            audio_player.stream = ambient_sound
            audio_player.play(0.0)
        else:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)
            audio_player.stream = ambient_sound
            audio_player.play(0.0)
        return
    
    GlobalSignalBus.altar_succeeded.connect(_on_cleanse)
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_cleanse(number: int, final_wave: bool):
    if should_play_before_cleanse and final_wave:
        spawn_sfx()
        
func spawn_sfx():
    if is_spatial:
        audio_player = AudioStreamPlayer3D.new()
        add_child(audio_player)
        audio_player.stream = ambient_sound
        audio_player.play(0.0)
    else:
        audio_player = AudioStreamPlayer.new()
        add_child(audio_player)
        audio_player.stream = ambient_sound
        audio_player.play(0.0)
