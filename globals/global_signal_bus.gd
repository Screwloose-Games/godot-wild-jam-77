extends Node

# Signals for general game events
signal title_screen_started
signal level_started(level_num: int)

# Signals for player-related events
signal player_health_changed(new_val: float)
signal player_hurt(amount: float)
signal player_healed(amount: float)
signal player_stepped(surface) # Needs SurfaceType enum
signal player_jumped
signal player_died
signal player_stopped_moving
signal player_started_idling
signal player_used_ability(ability)
signal player_landed(surface) # Needs SurfaceType enum

# Signals for enemy-related events
signal enemy_died(enemy: Enemy)
signal enemy_activated(enemy: Enemy)
signal enemy_queued_for_activation(enemy: Enemy)
signal enemy_hurt(enemy: Enemy, damage: int)
signal enemy_targeted_player(enemy: Enemy)

# Signals for altar-specific events
signal altar_activated
signal altar_failed
signal altar_succeeded

# Signals for menu-related events
signal main_menu_started
signal start_level_requested(level_num: int)

# Signals for game state events
signal game_paused
signal game_unpaused
