@tool
extends Resource
class_name ComponentResource 

var component: Node
var components_singleton: Node = null:
    set(n):
        components_singleton = get_autoload("Components")


@export var make_signals_global: bool = false:
    set(b):
        if get_autoload("Components") == null:
            make_signals_global = false
            return 
        if b == true:
            get_autoload("Components").add_signals(component)
            components_singleton = get_autoload("Components")
            make_signals_global = b
        else:
            make_signals_global = b
            get_autoload("Components").remove_signals(component)


static func get_autoload(node_path: NodePath) -> Variant:
    
    if !Engine.get_main_loop().root.has_node(node_path):
        push_error(node_path, ' Autoload FALSE, enable provided Components.gd autoload')
        return null
        
    return Engine.get_main_loop().root.get_node(node_path)


func _init(component_node: Node):
    component = component_node
    if make_signals_global: 
        components_singleton.add_signals(component)