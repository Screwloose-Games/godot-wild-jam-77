extends CanvasLayer
class_name TutorialCanvasLayer


signal continued

@export var cards: Array[String] = []

@onready var tutorial_continue_button: Button = %TutorialContinueButton
@onready var tut_text_container: RichTextLabel = %TutTextContainer

var text_index = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GlobalSignalBus.win_game_requirements_met.connect(_on_win_game_requirements_met)
    GlobalSignalBus.power_granted.connect(_on_power_granted)
    tutorial_continue_button.pressed.connect(_on_tut_continue_pressed)

func _process(delta: float) -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_tut_continue_pressed() -> void:
    continued.emit()
    hide()
    await get_tree().create_timer(0.2).timeout
    if cards_left():
        next()
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        process_mode = PROCESS_MODE_DISABLED
        var player = get_tree().get_first_node_in_group("Player")
        player.disabled = false

func cards_left() -> bool:
    return text_index < cards.size() - 1

func get_text():
    return cards[text_index]

func show_text(text: String):
    var player = get_tree().get_first_node_in_group("Player")
    player.disabled = true
    process_mode = PROCESS_MODE_ALWAYS
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    tutorial_continue_button.grab_focus()
    tutorial_continue_button.grab_click_focus()
    tut_text_container.text = text
    show()
    

func next():
    text_index += 1
    show_text(get_text())

func _on_power_granted(ability: Altar.AbilityType):
    show_power_help(ability)

func show_power_help(ability: Altar.AbilityType):
    match ability:
        Altar.AbilityType.MELEE:
            show_text("You have been granted a weapon. Attack with [color=red][u]LEFT MOUSE BUTTON[/u][/color].")
        Altar.AbilityType.RANGED:
            show_text("You feel power coursing through you. Hold [color=red][u]RIGHT MOUSE BUTTON[/u][/red] to fire a beam of energy.")
        Altar.AbilityType.SHIELD:
            show_text("A protective power surrounds you. Hold [color=green][u]TAB[/u][/color] to shield yourself.")
    get_tree().paused = true
    await continued
    get_tree().paused = false

func _on_win_game_requirements_met():
    win_game()
  
func win_game():
    show_text("[u]Congratulations![/u] You have cleansed the land and completed the metamorphosis! You win!")
    await continued
    get_tree().reload_current_scene.call_deferred()
