extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Settings_Menu.tscn")


func _on_quiz_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Quiz_Screen.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	#Hooray! You can close the game now!

func _on_scoreboard_button_pressed() -> void:
	#go to the scoreboard page
	get_tree().change_scene_to_file("res://Scoreboard.tscn")


func _on_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game_Screen.tscn")
	# This goes to the game yippee
