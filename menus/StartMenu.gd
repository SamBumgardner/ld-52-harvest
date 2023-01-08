extends Control

func _ready():
	if $TitleContentContainer/ButtonsContainer/StartButton:
		$TitleContentContainer/ButtonsContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://menus/LevelSelect.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
