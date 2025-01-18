extends CanvasLayer

@onready var continue_button = %ContinueButton
@onready var options_button = %OptionsButton
@onready var main_menu_button = %MainMenuButton
@onready var pause_menu_body = %PauseMenuBody

var main_menu_scene: PackedScene = SceneManager.MAIN_MENU
var options_menu_scene: PackedScene = SceneManager.OPTIONS_MENU


func _ready():
    #get_tree().paused = true
    visible = false
    continue_button.pressed.connect(on_continue_pressed)
    main_menu_button.pressed.connect(on_main_menu_pressed)
    options_button.pressed.connect(on_options_pressed)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        pause()

func pause():
    var should_pause = !get_tree().paused
    get_tree().paused = should_pause
    visible = should_pause

    if should_pause:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        GlobalSignalBus.game_paused.emit()
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        GlobalSignalBus.game_unpaused.emit()

func on_continue_pressed():
    pause()
    GlobalSignalBus.game_unpaused.emit()

func on_main_menu_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_packed(main_menu_scene)


func on_options_pressed():
    var options_menu_instance = options_menu_scene.instantiate()
    options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))
    pause_menu_body.visible = false
    add_child(options_menu_instance)

func on_options_back_pressed(options_menu: OptionsMenu):
    pause_menu_body.visible = true
    options_menu.queue_free()
