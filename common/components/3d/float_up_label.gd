extends Label3D
class_name FloatUpLabel3D

var displayed := false
@export var move_speed := 20.0
@export var lifetime := 1.0

func _ready() -> void:
    visible = false

func _process(delta):
    if displayed:
        position.y += move_speed * delta
        modulate.a = max(modulate.a -1.0 / lifetime * delta, 0)

func display(amount: float = 0):
    var shown_val = int(amount)
    text = str(shown_val)
    displayed = true
    visible = true
    await get_tree().create_timer(lifetime).timeout
    queue_free.call_deferred()
