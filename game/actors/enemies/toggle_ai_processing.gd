class_name ToggleAiProcessing
extends Node

## Node for toggling whether an AI entity should do processing
## Toggle AI on if the player is near, and off if the player moves away
## Controllers can check this node to see if they should be processing
## This should help with performance if we have many AI
## You could also toggle visuals too

signal processing_enabled
signal processing_disabled

var should_be_processing: bool = false : set = set_processing


func set_processing(do_process: bool):
    if do_process:
        processing_enabled.emit()
    else:
        processing_disabled.emit()
