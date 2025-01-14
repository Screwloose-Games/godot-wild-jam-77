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

var rotation_tolerance = 0.1

# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
    var target: Node3D = blackboard.get_var(target_var)
    if not is_instance_valid(target):
        return FAILURE
    var dir: Vector3 = target.global_position.direction_to(agent.global_position)
    #agent.velocity = Vector3.ZERO
    (agent as Actor3D).face_dir_lerp(dir, _delta)
    var rotation_to_dir = agent.rotation_to_direction(dir)
    if agent.rotation_to_direction(dir) < rotation_tolerance:
        return SUCCESS
    return RUNNING

func get_y_angle_difference(vec1: Vector3, vec2: Vector3) -> float:
    # Get the yaw angles of both vectors
    var angle1 = atan2(vec1.z, vec1.x)
    var angle2 = atan2(vec2.z, vec2.x)
    
    # Calculate the difference
    var angle_difference = angle2 - angle1
    
    # Normalize to the range [-PI, PI]
    angle_difference = wrapf(angle_difference, -PI, PI)
    
    # Convert to degrees if needed
    return rad_to_deg(angle_difference)
