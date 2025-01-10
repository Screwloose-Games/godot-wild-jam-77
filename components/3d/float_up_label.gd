extends Label
class_name FloatUpLabel3D

var displayed := false
var move_speed := 20.0
var lifetime := 1.0

func _process(delta):
    if displayed:
        position.y -= move_speed * delta
        self_modulate.a = max(self_modulate.a -1.0 / lifetime * delta, 0)


func display():
    displayed = true
    visible = true
    await get_tree().create_timer(lifetime).timeout
    queue_free.call_deferred()
