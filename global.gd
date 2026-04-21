extends Node

#the global variables file
#put variables here
#it autoloads in the loading screen
#variables will be updated as necessary if you load up the different settings


#loading in the default settings
var dyslexiaFont = false
var fontSize = 0 #OK we will adjust the default values later when we implement this

var fullScreen = false #Not entirely sure how we implement this though
'''
^ For Fullscreen:
extends Node # ik we're already gonna have there probably

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"): # idk what Fullscreen is, i can only assume a button?
		var mode := DisplayServer.window_get_mode() # honestly we can change this and next line for the variable
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
'''

var masterVolume = 100.0 #Default is 100% I guess
var sfxVolume = 100.0
var musicVolume = 100.0
#these change when you load the player's settings and the like in

# defaults to 0 (guest), stays that way when guest
# when logging in, it's the user id in the accounts database
var userID = 0

var gamescore = 0

var quizscore = 0

var incorrectanswers

# db prep if you're looking for it:
# questionsData.db: in game_load.gd
# accounts.db: in log_in.gd and sign_up.gd
