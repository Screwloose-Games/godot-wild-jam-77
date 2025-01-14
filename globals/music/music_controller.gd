extends Node

enum MUSIC_STATE { Title, Pause, Level, Altar }

@export var title_music: AudioStream
@export var level_music: AudioStream
@export var pause_music: AudioStream
@export var battle_music: AudioStream

var current_state = MUSIC_STATE.Title
var previous_state = MUSIC_STATE.Title

var elapsed_music_time = 0.0
var track_before_pause: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  GlobalSignalBus.title_screen_started.connect(_on_start_title)
  GlobalSignalBus.level_started.connect(_on_start_level)
  GlobalSignalBus.altar_activated.connect(_on_altar_begin)
  GlobalSignalBus.game_paused.connect(_on_start_pause)
  GlobalSignalBus.game_unpaused.connect(_on_stop_pause)
  
  _on_start_title()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

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
  elapsed_music_time = track_before_pause.get_playback_position()
  SoundManager.music.play(pause_music, 0.0, 1.0, 1.0, "")
  
## Resume from previous song time
func _on_stop_pause() -> void:
  set_music_state(previous_state)
  var previous_stream = track_before_pause.stream
  track_before_pause = SoundManager.music.play(previous_stream, elapsed_music_time, 1.0, 1.0, "")
  
func _on_start_level() -> void:
  if (current_state != MUSIC_STATE.Level):
    set_music_state(MUSIC_STATE.Level)
    track_before_pause = SoundManager.music.play(level_music, 0.0, 1.0, 1.5, "")
    
func _on_altar_begin() -> void:
  if (current_state != MUSIC_STATE.Altar):
    set_music_state(MUSIC_STATE.Altar)
    track_before_pause = SoundManager.music.play(battle_music, 0.0, 1.0, 0.5, "")
