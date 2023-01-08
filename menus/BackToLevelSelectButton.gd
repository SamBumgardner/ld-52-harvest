extends Control

func _ready():
	pass

func _on_ExitLevelButton_pressed():
	get_tree().change_scene("res://menus/LevelSelect.tscn")
