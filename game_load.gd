extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "THIS IS SUPPOSED TO BE A LOADING SCREEN HIT CONTINUE"
	#Load in anything that we need
	#This is the page with your load game, new game, etc data
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tempnext_pressed() -> void:
	get_tree().change_scene_to_file("res://Login_Screen.tscn")
