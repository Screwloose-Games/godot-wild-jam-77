extends Node

## Autoload, manages checkpoints (each altar is a checkpoint)

# File path on the user's machine to save checkpoint data to
const SAVE_PATH: String = "user://checkpoint_mgr.save"

# Track completed altars by their names (altar_power)
var completed_altars: Array[String]

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
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_var(completed_altars, false)
    file.store_var(latest_altar, false)
    file.close()
    print("Saved: ", completed_altars, ", ", latest_altar)
    pass


## Loads Checkpoint variables from user's local storage
func load_game():
    if FileAccess.file_exists(SAVE_PATH):
        var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
        completed_altars = file.get_var()
        latest_altar = file.get_var()
        print("Loaded: ", completed_altars, ", ", latest_altar)
    else:
        print("Failed to load game: No data to load")
    pass
