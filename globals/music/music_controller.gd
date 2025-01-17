extends Node

enum MUSIC_STATE { Title, Pause, Level, AltarFight, AltarCorruption,  }

@export var title_music: AudioStream
@export var level_music: AudioStream
@export var pause_music: AudioStream
@export var battle_music: AudioStream
@export var altar_success_music: Array[AudioStream]

@export var max_time_before_corruption_transition: float

var current_state = MUSIC_STATE.Title
var previous_state = MUSIC_STATE.Title

var elapsed_music_time = 0.0
var track_before_pause: AudioStreamPlayer

##Corruption timer
var corruption_music_timer = 0.0
var is_final_wave = false
var should_resume_corruption_timer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignalBus.title_screen_started.connect(_on_start_title)
    GlobalSignalBus.level_started.connect(_on_start_level)
    GlobalSignalBus.altar_activated.connect(_on_altar_begin)
    GlobalSignalBus.altar_succeeded.connect(_on_altar_success)
    GlobalSignalBus.game_paused.connect(_on_start_pause)
    GlobalSignalBus.game_unpaused.connect(_on_stop_pause)
  
    if get_tree().current_scene.name == "MainMenu":
        _on_start_title()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if should_resume_corruption_timer:
        corruption_music_timer += delta
        
        if corruption_music_timer >= max_time_before_corruption_transition:
            stop_altar_music()

func set_music_state(new_state: MUSIC_STATE) -> void:
    previous_state = current_state
    current_state = new_state

func _on_start_title() -> void:
    set_music_state(MUSIC_STATE.Title)
    SoundManager.music.play(title_music, 0.0, 1.0, 2.0, "")
  
func _on_stop_title() -> void:
    SoundManager.music.stop(2.0)
  
func _on_start_pause() -> void:
    previous_state = current_state
    set_music_state(MUSIC_STATE.Pause)
    
    ##check corruption timer
    if previous_state == MUSIC_STATE.AltarCorruption:
        should_resume_corruption_timer = false
    
    if track_before_pause:
        elapsed_music_time = track_before_pause.get_playback_position()
    SoundManager.music.play(pause_music, 0.0, 1.0, 0.25, "")
  
## Resume from previous song time
func _on_stop_pause() -> void:
    set_music_state(previous_state)
    
    ##check corruption timer, don't play if it's already trailing off
    if previous_state == MUSIC_STATE.AltarCorruption:
        if max_time_before_corruption_transition - corruption_music_timer <= 0.25:
            should_resume_corruption_timer = false
            corruption_music_timer = 0.0 
        else:
            should_resume_corruption_timer = true
    
    if track_before_pause:
        var previous_stream = track_before_pause.stream
        track_before_pause = SoundManager.music.play(previous_stream, elapsed_music_time, 1.0, 0.25, "")
    else:
        SoundManager.music.stop(0.25)
  
func _on_start_level() -> void:
    if (current_state != MUSIC_STATE.Level):
        set_music_state(MUSIC_STATE.Level)
        track_before_pause = SoundManager.music.play(level_music, 0.0, 1.0, 1.5, "")
    
func _on_altar_begin() -> void:
    if (current_state != MUSIC_STATE.AltarFight):
        set_music_state(MUSIC_STATE.AltarFight)
        track_before_pause = SoundManager.music.play(battle_music, 0.0, 1.0, 0.5, "")
        
func _on_altar_success(wave_number: int, final_wave: bool) -> void:
    is_final_wave = final_wave
    if (current_state != MUSIC_STATE.AltarCorruption):
        set_music_state(MUSIC_STATE.AltarCorruption)
        if wave_number > 1:
            track_before_pause = SoundManager.music.play(altar_success_music[2], 0.0, 1.0, 0.1, "")
        else:
            track_before_pause = SoundManager.music.play(altar_success_music[wave_number], 0.0, 1.0, 0.1, "")
        
func stop_altar_music() -> void:
    should_resume_corruption_timer = false
    corruption_music_timer = 0.0
    ##Do level music
    if is_final_wave:
        _on_start_level()
    else:
        _on_altar_begin()
        
func _on_altar_fail() -> void:
    pass
