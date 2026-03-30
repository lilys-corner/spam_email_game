extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "THIS IS SUPPOSED TO BE A LOADING SCREEN HIT CONTINUE"
	#Load in anything that we need
	#This is the page with your load game, new game, etc data
	
	
	#and then we have the go to next page function actually
	#Basically: load in things
	#then immediately swap to next page
	# IF YOU BASICALLY DON'T SEE THIS PAGE IT IS WORKING AS INTENDED
	get_tree().change_scene_to_file("res://Login_Screen.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tempnext_pressed() -> void:
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
