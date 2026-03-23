extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# load in any necessary data, start global variables
	#Show any necessary logos and things
	#Automatically move to the next screen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#This is probably not necessary honestly
	


func _on_temp_button_pressed() -> void:
	# really just a temporary thing
	# delete it once we actually have the loading screen code
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
