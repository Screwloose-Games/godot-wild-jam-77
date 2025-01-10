extends Control

@export var themes: Array[Theme]
@export var base_fonts: Array[FontFile]

var font: FontVariation = preload("res://assets/fonts/body_font.tres")

var index: int = 0
var font_index: int = 0
var elapsed_time: float = 0.0
var update_interval: float = 0.2  # Update every 0.2 seconds

func _ready() -> void:
    # Create and configure a Timer node
    var timer = Timer.new()
    timer.wait_time = 0.5  # Set the timer interval to 0.5 seconds
    timer.autostart = true
    timer.one_shot = false
    add_child(timer)
    timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
    elapsed_time += delta
    if elapsed_time >= update_interval:
        elapsed_time = 0.0  # Reset the elapsed time
        if base_fonts.size() > 0:
            font.base_font = base_fonts[font_index]
            font_index = (font_index + 1) % base_fonts.size()  # Loop back to the first font

func _on_timer_timeout() -> void:
    if themes.size() > 0:
        theme = themes[index]
        index = (index + 1) % themes.size()  # Loop back to the first theme
