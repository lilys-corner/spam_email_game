extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#volumes
	$overallVolume.value = Global.masterVolume
	$musicVolume.value = Global.musicVolume
	$sfxVolume.value = Global.sfxVolume
	
	#set the actual volumes of the back and click sfx
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$clickSFX.set_volume_linear(sfxVol)
	$backSFX.set_volume_linear(sfxVol)

func _process(delta: float) -> void:
	pass

#Travel back to menu
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu.tscn")

func _on_h_slider_changed() -> void:
	pass # Replace with function body.

func _on_cancel_settings_pressed() -> void:
	#set all settings back to how it was before
	$overallVolume.value = Global.masterVolume
	$musicVolume.value = Global.musicVolume
	$sfxVolume.value = Global.sfxVolume

func _on_save_settings_pressed() -> void:
	#save settings to the global variables
	Global.masterVolume = $overallVolume.value
	Global.musicVolume = $musicVolume.value
	Global.sfxVolume = $sfxVolume.value
	
	#recalculating the volume
	var sfxVol = 1*(Global.masterVolume/100)*(Global.sfxVolume/100)
	$clickSFX.set_volume_linear(sfxVol)
	$backSFX.set_volume_linear(sfxVol)

#Larger Font Size Toggle
func _on_check_button_toggled(toggled_on: bool) -> void:
	#Sound Effects
	$clickSFX.play()
	#Load in Themes for text sizing
	var settings_theme = preload("res://settings_theme.tres")
	var quiz_theme = preload("res://quiz_theme.tres")
	var score_values_theme = preload("res://scoreboard_rank_theme.tres")
	var results_label_theme = preload("res://results_label_theme.tres")
	var results_text_theme = preload("res://results_text_theme.tres")
	
	if(toggled_on == true):
		settings_theme.set_font_size("font_size", "Label", 34)
		settings_theme.set_font_size("font_size", "CheckButton", 34)
		quiz_theme.set_font_size("normal_font_size", "RichTextLabel", 35)
		score_values_theme.set_font_size("font_size", "Label", 36)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 50)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 38)
		
	else:
		settings_theme.set_font_size("font_size", "Label", 24)
		settings_theme.set_font_size("font_size", "CheckButton", 24)
		quiz_theme.set_font_size("normal_font_size", "RichTextLabel", 28)
		score_values_theme.set_font_size("font_size", "Label", 26)
		results_label_theme.set_font_size("normal_font_size", "RichTextLabel", 40)
		results_text_theme.set_font_size("normal_font_size", "RichTextLabel", 28)

#Dyslexia Font Toggle
func _on_dys_font_toggled(toggled_on: bool) -> void:
	if (toggled_on == true):
		ThemeDB.get_default_theme().default_font = Global.dyslexiaFont
	else:
		ThemeDB.get_default_theme().default_font = null
		pass # Replace with function body.
