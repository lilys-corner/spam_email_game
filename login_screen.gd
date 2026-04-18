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
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
