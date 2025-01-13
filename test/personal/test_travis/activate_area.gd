extends Area3D

signal do_activate

# Called when the node enters the scene tree for the first time.
func _ready():
    body_entered.connect(on_body_entered)
    pass # Replace with function body.


func on_body_entered(body: Node3D):
    if body is PlayerController:
        do_activate.emit()
