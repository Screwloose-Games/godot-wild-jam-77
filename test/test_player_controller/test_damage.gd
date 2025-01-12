extends CSGTorus3D

@onready var hit_box_component_3d: HitBoxComponent3D = %HitBoxComponent3D

# Timer for handling periodic attacks
var attack_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Initialize and start the timer for attacking every 0.5 seconds
    attack_timer = Timer.new()
    attack_timer.wait_time = 0.5
    attack_timer.one_shot = false
    attack_timer.autostart = true
    add_child(attack_timer)
    attack_timer.connect("timeout",  _on_attack_timer_timeout)

func _on_attack_timer_timeout():
    attack()

func attack():
    # Activate hit box
    hit_box_component_3d.activate()
    
    # Modulate to black for 0.1 seconds
    self.material.albedo_color = Color.BLACK
    
    var tree = get_tree()
    if is_instance_valid(tree):
        await tree.create_timer(0.1).timeout
    self.material.albedo_color = Color.WHITE
