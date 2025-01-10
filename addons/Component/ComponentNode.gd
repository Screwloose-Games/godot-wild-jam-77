@tool
extends Node
class_name ComponentNode 

@export var global_signals: bool:
    set(b):
        component_resource.make_signals_global = b
    get:
        return component_resource.make_signals_global

var component_resource: ComponentResource = ComponentResource.new(self)