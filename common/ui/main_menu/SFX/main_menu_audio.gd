extends Control

##Audio
@export var navigate_sound: AudioStream
@export var open_sound: AudioStream
@export var close_sound: AudioStream


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
    

func _on_open():
    SoundManager.play_ui_sound(open_sound)
    
    
func _on_close():
    SoundManager.play_ui_sound(close_sound)


func _on_hover():
    SoundManager.play_ui_sound(navigate_sound)


func _on_master_hover():
    SoundManager.play_ui_sound(navigate_sound)

func _on_music_hover():
    SoundManager.play_ui_sound(navigate_sound)

func _on_sfx_hover():
    SoundManager.play_ui_sound(navigate_sound)
