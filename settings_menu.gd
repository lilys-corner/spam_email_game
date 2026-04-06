extends Control
#Hello and welcome to my Settings Menu Script
#OK I honestly wish that I had my second monitor for this but you know. whatever.

#LIST OF SETTINGS
# Fullscreen (ON/OFF)
# Volume (3 subcategories)
#   Overall Volume (Slider)
#   SFX Volume (Slider)
#   Music Volume (Slider)
# Readable Font
#Ok I've got a question is this just the
#dyslexia font option or is there also the font sizing thing


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set up the fullscreen etc
	#Global.sfxVolume = 50.0
	
	#volumes
	$overallVolume.value = Global.masterVolume
	$musicVolume.value = Global.musicVolume
	$sfxVolume.value = Global.sfxVolume
	#Listen I will go and fix the width later. or someone else fix the width later.
	#it's just all weird and not the same length we just need it to look better
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_temp_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
	#We are going to need to change the texture later
	#This one does *not* get deleted I think it's a good idea to simply not allow
	#The player to get stuck in the settings menu for the rest of their life


func _on_h_slider_changed() -> void:
	pass # Replace with function body.


func _on_cancel_settings_pressed() -> void:
	#set all settings back to how it was before
	$overallVolume.value = Global.masterVolume
	$musicVolume.value = Global.musicVolume
	$sfxVolume.value = Global.sfxVolume


func _on_save_settings_pressed() -> void:
	#save settings to the global variables. and maybe in to the
	#player's settings file or something idfk
	Global.masterVolume = $overallVolume.value
	Global.musicVolume = $musicVolume.value
	Global.sfxVolume = $sfxVolume.value
	pass # Replace with function body.


func _on_check_button_toggled(toggled_on: bool) -> void:
	#volume math
	#This isn't working btw
	#I'm not sure why
	#If anyone can figure it out that'd be awesome I'll keep trying to
	#figure it out though
	var sfxVol = 0 + (Global.masterVolume * Global.sfxVolume)/2000
	$clickSFX.volume_db = sfxVol
	
	$clickSFX.play()
	if(toggled_on == true):
		pass
	else:
		pass
		
