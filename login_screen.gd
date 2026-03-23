extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_temp_button_pressed() -> void:
	#remove later. I don't care. I'm just setting up a skeleton
	#I'm scared of how the logins will work
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
