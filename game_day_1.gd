extends Control

#setting up necessary variables
#Is the options menu available?
var options1 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	
	var optionsPosition = Vector2(0.0, 0.0)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if options1 == false:
				optionsPosition = Vector2(760.0, 340.0)
				options1 = true
			else:
				optionsPosition = Vector2(760.0, -400.0)
				options1 = false
			#replace with the options menu
			
			$optionsMenu.set_position(optionsPosition)
			
