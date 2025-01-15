extends Node3D

@export var altar: Altar

func _ready() -> void:
    for child in get_children():
        if child is Enemy:
            altar.assign_enemy(child)
            child.process_mode = Node.PROCESS_MODE_ALWAYS
            child.apply_floor_snap()
            child.move_and_slide()

    await get_tree().process_frame
    for child in get_children():
        if child is Enemy:
            child.process_mode = Node.PROCESS_MODE_DISABLED
