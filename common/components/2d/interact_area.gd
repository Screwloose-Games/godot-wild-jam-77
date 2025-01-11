extends Area2D
class_name InteractArea2D

var tracked_nodes: Array[Node2D] = []
var selected: Node2D = null

var player: PlayerController

func _ready():
    process_mode = PROCESS_MODE_ALWAYS
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)
    if not player:
        player = get_parent()

func _on_area_entered(area: Area2D):
    if area.is_in_group("Interactable"):
        for tracked in tracked_nodes:
            tracked.unselect()
        tracked_nodes.append(area)
        area.select()
        selected = area

func select_closest():
    for tracked in tracked_nodes:
        tracked.unselect()
    if tracked_nodes.size() > 0:
        tracked_nodes[0].select()
        selected = tracked_nodes[0]

func _on_area_exited(area: Area2D):
    if area.is_in_group("Interactable"):
        area.unselect()
        tracked_nodes.erase(area)
        if tracked_nodes.size() > 0:
            selected = tracked_nodes[0]
            selected.select()
        else:
            selected = null

#func _process(delta):
    ##get_overlapping_areas()
    #if Input.is_action_just_pressed("interact"):
        #if selected:
            #selected.interact(player)

func _unhandled_input(event):
    if event.is_action_pressed("interact"):
        if selected:
            selected.interact(player)
            
