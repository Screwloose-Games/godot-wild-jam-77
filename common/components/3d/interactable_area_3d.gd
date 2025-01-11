extends Area3D
class_name InteractableArea3D

signal interacted(player: PlayerController)
signal stopped_interacting

var is_interacting: bool = false
var selected = false:
    set = set_selected

func _ready():
    stopped_interacting.connect(_on_stopped_interacting)

func _on_stopped_interacting():
    is_interacting = false

func select():
    selected = true

func unselect():
    selected = false

func set_selected(val: bool):
    selected = val

func interact(player: PlayerController):
    if is_interacting:
        return
    interacted.emit(player)
    print("interacted")
    is_interacting = true
