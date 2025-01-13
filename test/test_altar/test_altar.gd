extends Node3D




func _on_progress_slider_value_changed(value: float) -> void:
    $Altar.purafication_progress = value
    $Altar/purafication_range/CollisionShape3D.disabled = false
    $Progress_Slider/Label.text = str("Purifacation Progress: ",value)
