extends Node

## Melee Enemy Controller
## Connects all of the components that make up the behavior of the melee enemy

# This is the mob we will be controlling
@onready var mob: BaseEntity = $".."
@onready var toggle_ai_processing: ToggleAiProcessing = $ToggleAiProcessing
@onready var detect_entities: DetectEntities = $DetectEntities

@onready var entity_blackboard: EntityBlackboard = $EntityBlackboard
@onready var rescan_entities_timer: Timer = $RescanEntitiesTimer


func _ready():
    # Once the entity is activated, start running the AI processing
    mob.entity_activated.connect(func(): toggle_ai_processing.should_be_processing = true)
    
    pass


func _physics_process(delta):
    # TODO if dead, return
    
    if not toggle_ai_processing.should_be_processing:
        return
    
    
    
    mob.move_and_slide()
    pass
