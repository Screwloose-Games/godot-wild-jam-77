#*
#* pursue.gd
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
## Move towards the target until the agent is flanking it. [br]
## Returns [code]RUNNING[/code] while moving towards the target but not yet at the desired position. [br]
## Returns [code]SUCCESS[/code] when at the desired position relative to the target (flanking it). [br]
## Returns [code]FAILURE[/code] if the target is not a valid [Node3D] instance. [br]

## How close should the agent be to the desired position to return SUCCESS.
const TOLERANCE := 2.0

## Blackboard variable that stores our target (expecting Node3D).
@export var target_var: StringName = &"target"

## Blackboard variable that stores desired speed.
@export var speed_var: StringName = &"speed"

## Desired distance from target.
@export var approach_distance: float = 100.0

var _waypoint: Vector3

var nav_agent: NavigationAgent3D

var movement_delta: float

# Display a customized name (requires @tool).
func _generate_name() -> String:
    return "Pursue %s" % [LimboUtility.decorate_var(target_var)]


# Called each time this task is entered.
func _enter() -> void:
    var target: Node3D = blackboard.get_var(target_var, null)
    nav_agent = agent.nav_agent
    
    if is_instance_valid(target):
        # Movement is performed in smaller steps.
        # For each step, we select a new waypoint.
        nav_agent.set_target_position(target.global_position)

# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
    if NavigationServer3D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
        return FAILURE
    var target: Node3D = blackboard.get_var(target_var, null)
    if not is_instance_valid(target):
        return FAILURE
    
    var speed: float = blackboard.get_var(speed_var, 200.0)
    movement_delta = speed * _delta
    var next_path_position: Vector3 = nav_agent.get_next_path_position()
    var new_velocity: Vector3 = agent.global_position.direction_to(next_path_position) * movement_delta
    if nav_agent.avoidance_enabled:
        nav_agent.set_velocity(new_velocity)
    else:
        _on_velocity_computed(new_velocity)

    var desired_pos: Vector3 = nav_agent.get_final_position()
    if agent.global_position.distance_to(desired_pos) < TOLERANCE:
        return SUCCESS

    return RUNNING

func _on_velocity_computed(safe_velocity: Vector3) -> void:
    agent.global_position = agent.global_position.move_toward(agent.global_position + safe_velocity, movement_delta)
    print(agent.global_position)

## Get the closest flanking position to target.
func _get_desired_position(target: Node3D) -> Vector3:
    return target.global_position
    #var side: float = signf(agent.global_position.x - target.global_position.x)
    #var desired_pos: Vector3 = target.global_position
    #desired_pos.x += approach_distance * side
    #return desired_pos

## Select an intermidiate waypoint towards the desired position.
func _select_new_waypoint(desired_position: Vector3) -> void:
    nav_agent
    var distance_vector: Vector3 = desired_position - agent.global_position
    var angle_variation: float = randf_range(-0.2, 0.2)
    _waypoint = agent.global_position + distance_vector.limit_length(150.0).rotated(Vector3.UP, angle_variation)
