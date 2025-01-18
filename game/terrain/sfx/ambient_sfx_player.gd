extends Node3D

@export var ambient_sound: AudioStream
@export var is_spatial: bool = false
@export var should_play_before_cleanse: bool = false
@export_range(0, 1) var volume: float

var audio_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    await get_tree().create_timer(0.2).timeout
    if should_play_before_cleanse:     
        spawn_sfx()
        return
        
    GlobalSignalBus.altar_succeeded.connect(_on_cleanse)
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_cleanse(number: int, final_wave: bool):
    if not should_play_before_cleanse and final_wave:
        spawn_sfx()
        
func spawn_sfx():
    if is_spatial:
        audio_player = AudioStreamPlayer3D.new()
    else:
        audio_player = AudioStreamPlayer.new()
            
    add_child(audio_player)
    audio_player.stream = ambient_sound
    audio_player.volume_db = linear_to_db(volume)
    audio_player.play(0.0)
