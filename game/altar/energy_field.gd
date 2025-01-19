extends CSGCylinder3D

var starting_height = 0
@export var final_height = 5

@export var duration: float = 1

@export var min_radius: float = 1.0
@export_range(0.5, 10) var max_radius: float = 10

func _ready() -> void:
    visible = false
    height = starting_height

func _on_altar_activated() -> void:
    visible = true
    var tween = get_tree().create_tween()
    tween.tween_property(self, "height", final_height, duration)

func _on_altar_purified_amount(amount_purified: float) -> void:
    amount_purified = clamp(amount_purified, 0.0, 1.0)
    
    radius = lerp(min_radius, max_radius, amount_purified)
    
    # Hide this if fully purified
    if amount_purified >= 1.0:
        visible = false
