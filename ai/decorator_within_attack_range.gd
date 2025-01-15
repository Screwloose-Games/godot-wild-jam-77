extends BTDecorator

## Target is within attack range
func _tick(_delta: float):
    var attack_range = blackboard.get_var("attack_range")
    var target_distance = blackboard.get_var("taget_distance")
    var is_within_attack_range = target_distance < attack_range
    if (is_within_attack_range):
        return RUNNING
    return FAILURE
