extends CanvasLayer

func _input(event):
    if event.is_action_pressed("escape"):
        close_all_overlays()
        get_viewport().set_input_as_handled()

func close_all_overlays():
    var all_overlays = get_tree().get_nodes_in_group("Overlay")
    for overlay in all_overlays:
        if overlay.has_method("hide"):
            overlay.hide()
