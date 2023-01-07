extends Control

var _first_opened = true

func _ready():
	_first_opened = true
	if $TitleContentContainer/ButtonsContainer/StartButton:
		$TitleContentContainer/ButtonsContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://GameplayTest.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
