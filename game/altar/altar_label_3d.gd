extends Label3D

@onready var interactable_area_3d: InteractableArea3D = %InteractableArea3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    visible = false
    interactable_area_3d.area_entered.connect(_on_interactable_area_entered)
    interactable_area_3d.area_exited.connect(_on_interactable_area_exited)

func _on_interactable_area_entered(area):
    visible = true

func _on_interactable_area_exited(area):
    visible = false
