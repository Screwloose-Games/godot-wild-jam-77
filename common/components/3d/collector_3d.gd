extends Area3D
class_name  Collector3D

@export var recipient: CharacterBody3D
@export var collected_label: Label

func _ready():
    if recipient == null:
        recipient = get_parent()
    area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
    if area.has_method("get_collected"):
        collect(area)

func collect(collectable: Collectable3D):
    collectable.get_collected(recipient)
    display_collected_text()

func display_collected_text():
    var collected_lbl = collected_label.duplicate()
    add_child(collected_lbl)
    collected_lbl.display()
