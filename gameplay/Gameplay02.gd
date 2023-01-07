extends Node2D

func _ready():
	if $BackButton:
		$BackButton.grab_focus()

func _on_BackButton_pressed():
	get_tree().change_scene("res://menus/StartMenu.tscn")
