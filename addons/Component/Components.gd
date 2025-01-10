@tool
extends Node

func add_signals(component: Node):
    for sig in component.get_signal_list():
        if ComponentResource.get_autoload("Components") == null: 
            push_warning("Component Autoload not active") 
            return
        
        if has_signal(sig.name): 
            continue

        add_user_signal(sig.name, sig.args)
        print("Added Signal " + sig.name)


func remove_signals(component: Node):
    for sig in component.get_signal_list():
        if ComponentResource.get_autoload("Components") == null: 
            push_warning("Component Autoload not active") 
            return
        
        if has_user_signal(sig.name): 
            remove_user_signal(sig.name)
            print("Removed signal " + sig.name)
        

func _init():
    if ComponentResource.get_autoload("Components") == null: 
        print("Components Autoload added")
    else:
        print("Components Autoload removed")
