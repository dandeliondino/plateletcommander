extends Node


# LEVELS
signal level_change_requested(value, travel_type)
signal level_changing(from_level, to_level)
signal level_unloading
signal level_unloaded
signal level_loading
signal level_loaded

signal fade_to_black_requested
signal faded_to_black
signal fade_to_game_requested
signal faded_to_game



# UI
signal game_state_exit_requested
signal game_state_change_requested(value)
signal game_state_changed(from_value, to_value)

signal move_state_requested

# Menus/Panels
signal main_menu_requested
# put panel requests here

# MoreInfoPanel
signal more_info_panel_requested(path)

# ConfirmationBox
signal confirmation_popup_requested(params)
signal confirmation_option_chosen(value)

# Entities
signal entity_selected(entity)
signal entity_focus_gained(entity)
signal entity_focus_lost(entity)
signal entity_cell_changed(entity, from_cell, to_cell)

signal apply_powerup_requested(id)
signal powerup_used(id)
signal powerup_added(id)
signal powerup_count_refresh_requested
signal platelet_dropped(spot)

signal connection_made
signal connection_upgraded
