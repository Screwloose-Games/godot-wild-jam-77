extends Node

## Autoload, manages checkpoints (each altar is a checkpoint)

# File path on the user's machine to save checkpoint data to
const SAVE_PATH: String = "user://checkpoint_mgr.save"

# Track completed altars by their names (altar_power)
var completed_altars: Array

# The latest altar we are fighting at
# If you die at an altar during the altar's challenge, you want to respawn there to try again
var latest_altar: String


func _ready():
    # Try loading checkpoint data when the game starts
    load_game()
    pass


## Call when the player arrives at an altar to save their progress
func arrived_at_altar(altar_power: String):
    latest_altar = altar_power
    print("Saving game...")
    save_game()


## Call after a player completes the altar's challenge
func altar_completed(completed_altar_power: String):
    completed_altars.append(completed_altar_power)
    latest_altar = completed_altar_power
    
    print("Saving game...")
    save_game()


## Saves Checkpoint variables to user's local storage
func save_game():
    var save_dict: Dictionary = {
        "completed_altars" : completed_altars,
        "latest_altar" : latest_altar,
    }
    var json_string: String = JSON.stringify(save_dict)
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_line(json_string)
    file.close()
    print("Saved: ", save_dict)
    pass


## Loads Checkpoint variables from user's local storage
func load_game():
    if not FileAccess.file_exists(SAVE_PATH):
        print("Failed to load game: No data to load")
        return
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    while file.get_position() < file.get_length():
        var json_string: String = file.get_line()
        var json = JSON.new()
        var parse_result: Error = json.parse(json_string)
        if parse_result != OK:
            print("Error loading game: ", parse_result)
            continue
        var node_data = json.data
        if node_data is Dictionary:
            if node_data.has("completed_altars"):
                completed_altars = node_data.get("completed_altars")
            if node_data.has("latest_altar"):
                latest_altar = node_data.get("latest_altar")
            pass
        print("Loaded data: ", node_data)
        
    pass


func delete_save_data():
    var empty_array: Array
    var save_dict: Dictionary = {
        "completed_altars" : empty_array,
        "latest_altar" : "",
    }
    var json_string: String = JSON.stringify(save_dict)
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_line(json_string)
    file.close()
    print("Deleted save data.")
