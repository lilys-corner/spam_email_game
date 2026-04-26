extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Functions for when specific buttons are pressed on the Main Menu
#Settings/Options Button
func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Settings_Menu.tscn")

#Quiz Button
func _on_quiz_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Quiz_Screen.tscn")

#Exit Button
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
#Scoreboard/Leaderboard Button
func _on_scoreboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scoreboard.tscn")

#Game Button
func _on_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game_Screen.tscn")
