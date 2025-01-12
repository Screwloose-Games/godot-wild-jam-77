extends Node

@onready var activate_altar = $"../../ActivateAltar"
@onready var purify_altar = $"../../FinishAltar"
@onready var altar = $".."

func _ready():
    activate_altar.do_activate.connect(altar.activate)
    purify_altar.do_activate.connect(altar.purify_altar)
