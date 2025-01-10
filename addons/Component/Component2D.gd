@tool
extends Node2D
class_name Component2D 

@export var global_signals: bool:
    set(b):
        component_resource.make_signals_global = b
    get:
        return component_resource.make_signals_global

var component_resource: ComponentResource = ComponentResource.new(self)
