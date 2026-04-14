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
Commented bc idk where to put this but this is the code for swapping
func _process(_delta):
	if Input.is_action_just_pressed("full_screen"): // idk what full_screen is exactly tho
		fullscreen = not fullscreen
		toggle_fullscreen()

func toggle_fullscreen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)'''

var masterVolume = 100.0 #Default is 100% I guess
var sfxVolume = 100.0
var musicVolume = 100.0
#these change when you load the player's settings and the like in

#Next thing to load in
#Any database prep, probably
#Honestly I have no idea how we're going about integrating the database
