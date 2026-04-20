extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	# i think this is where we calculate score
	
	# here is where the score will be saved to the leaderboard
	# it'll save regardless if it's top 10
	# showing only top 10 is a problem for the leaderboard page


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	# if you're done here go back to the main menu
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
