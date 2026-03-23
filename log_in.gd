extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#We are going to need to make the text boxes visible soon
	#Remind me to do that. I can make them okay later.
	#I just have to make it exist first
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_submit_button_pressed() -> void:
	#wow! It's a submit button
	#when you click this, you submit the text in the EnterUsername
	#and EnterPassword boxes
	#and then it gets compared to the data in the database
	#and accepts if the username and password match and gives the user a warning if they don't
	#think like "Username or password is incorrect"
	
	var Username = $EnterUsername.text_submitted()
	var Password = $EnterPassword.text_submitted()
	
	pass # Replace with function body.

#Honestly I'm not entirely sure what I'm doing here
#The point is that I want it so that you can submit the username
#And password with the submit button
#And not have to hit enter for the two individual username and password boxes seperately
#Unfortunately I have not a single clue how to go about doing that
 
func _on_enter_username_text_submitted(new_text: String) -> void:
	pass # Replace with function body.
