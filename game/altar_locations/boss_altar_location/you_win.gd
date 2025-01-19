extends Node

@onready var altar: Altar = %Altar

func _ready() -> void:
    altar.purified.connect(_on_altar_purified)

func _on_altar_purified():
    GlobalSignalBus.win_game_requirements_met.emit()
