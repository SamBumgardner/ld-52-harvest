extends Control

onready var start_button = $TitleContentContainer/ButtonsContainer/StartButton as Button

func _ready():
	start_button.grab_focus()

func _on_CreditsButton_pressed():
	get_tree().change_scene("res://menus/CreditsMenu.tscn")

func _on_StartButton_pressed():
	get_tree().change_scene("res://menus/LevelSelect.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
