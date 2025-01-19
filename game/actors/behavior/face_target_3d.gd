#*
#* face_target.gd
#* =============================================================================
#* Copyright 2021-2024 Serhii Snitsaruk
#*
#* Use of this source code is governed by an MIT-style
#* license that can be found in the LICENSE file or at
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
@tool
extends BTAction
## Flips the agent to face the target, returning [code]SUCCESS[/code]. [br]
## Returns [code]FAILURE[/code] if [member target_var] is not a valid [Node2D] instance.

## Blackboard variable that stores our target (expecting Node2D).
@export var target_var: StringName = &"target"

# Display a customized name (requires @tool).
func _generate_name() -> String:
    return "FaceTarget " + LimboUtility.decorate_var(target_var)

# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
    var target: Node3D = blackboard.get_var(target_var)
    if not is_instance_valid(target):
        return FAILURE
    var dir: Vector3 = target.global_position.direction_to(agent.global_position)
    var current_rotation = agent.global_transform.basis.get_rotation_quaternion()
    var target_direction = (target.global_position - agent.global_transform.origin).normalized()
    var target_rotation = Basis.looking_at(target_direction).get_rotation_quaternion()
    var new_rotation = current_rotation.slerp(target_rotation, agent.turning_speed * _delta)
    agent.global_transform.basis = Basis(new_rotation)
    if agent.rotation_to_direction(dir) < agent.attack_rotation_tolerance_degrees:
        return SUCCESS
    return RUNNING
