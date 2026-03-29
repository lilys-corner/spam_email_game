extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#basically this is where we pull the top scores (top 10?)
	#from the database
	#and then put them into a bunch of rich text labels or just labels
	$tempLabel.text = "SCOREBOARD PAGE"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
