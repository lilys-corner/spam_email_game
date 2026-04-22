extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_log_in_pressed() -> void:
	#go to log in screen upon clicking login button (top)
	get_tree().change_scene_to_file("res://Log_In.tscn")

func _on_sign_up_pressed() -> void:
	#go to sign up screen upon clicking signup button (top)
	get_tree().change_scene_to_file("res://Sign_Up.tscn")

func _on_guest_button_pressed() -> void:
	# global user id is already 0, but just to be safe
	# 0 is not an id in the database, account ids start at 1
	Global.userID = 0
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

# this is temporary to get me to the results screen to avoid doing the 20 questions
func _on_temp_button_pressed() -> void:
	Global.quizscore = 80
	Global.incorrectquiz.resize(4)
	Global.incorrectquiz = [4, 9, 21, 40]
	get_tree().change_scene_to_file("res://Results_Screen.tscn")
