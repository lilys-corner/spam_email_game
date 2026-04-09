extends Control

#setting up necessary variables
#Is the options menu available?
var options1 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%overallVolume.value = Global.masterVolume
	%musicVolume.value = Global.musicVolume
	%sfxVolume.value = Global.sfxVolume
	
	#set the actual volumes of the back and click sfx
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	#%clickSFX.set_volume_linear(sfxVol)
	#%backSFX.set_volume_linear(sfxVol)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#So here's what we need
#X button at the top to close it
#Settings: fullscreen
#Overall sound
#Music vol
#SFX vol
#big text toggle
#Saving off the settings
#Quit game
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
			
			$opBKG.global_position(optionsPosition)
			

#Close already open menu
func _on_exit_menu_pressed() -> void:
	var options1 = false
	$opBKG.global_position(Vector2(760.0, -400.0))
	#Closes the options menu
	
#Save options


func _on_save_opt_pressed() -> void:
	#save settings to the global variables. and maybe in to the
	#player's settings file or something idfk
	Global.masterVolume = $overallVolume.value
	Global.musicVolume = $musicVolume.value
	Global.sfxVolume = $sfxVolume.value
	
	#recalculating the volume
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$clickSFX.set_volume_linear(sfxVol)
	$backSFX.set_volume_linear(sfxVol)


func _on_cancel_opt_pressed() -> void:
	$overallVolume.value = Global.masterVolume
	$musicVolume.value = Global.musicVolume
	$sfxVolume.value = Global.sfxVolume


func _on_quit_game_pressed() -> void:
	#fuck my stupid malevolent life
	#i. i don't care. no confirmation screen.
	#I'm not programming that
	#We can add a note underneath it I don't care
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
