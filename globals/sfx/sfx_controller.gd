extends Node

@export var pause_sound: AudioStream
@export var unpause_sound: AudioStream

@export var altar_failed_sound: AudioStream
@export var altar_purified_sound: AudioStream
@export var altar_purifying_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignalBus.game_paused.connect(_start_pause)
    GlobalSignalBus.game_unpaused.connect(_end_pause)
    GlobalSignalBus.altar_activated.connect(_on_start_altar)
    GlobalSignalBus.altar_failed.connect(_on_altar_fail)
    GlobalSignalBus.altar_succeeded.connect(_on_altar_purified)
    GlobalSignalBus.enemy_died.connect(_on_enemy_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _start_pause():
    SoundManager.play_ui_sound(pause_sound)
    
func _end_pause():
    SoundManager.play_ui_sound(unpause_sound)

func _on_altar_fail():
    SoundManager.play_ui_sound(altar_failed_sound)
    
func _on_altar_purified():
    SoundManager.play_ui_sound(altar_purified_sound)

func _on_start_altar():
    SoundManager.play_ui_sound(altar_purifying_sound)
    
func _on_enemy_death():
    await get_tree().create_timer(0.5)
    SoundManager.play_ui_sound(altar_purifying_sound)
