extends Control

func _ready():
	Input.set_custom_mouse_cursor(null, CURSOR_ARROW)
	if $TitleContentContainer/ButtonsContainer/LevelButton01:
		$TitleContentContainer/ButtonsContainer/LevelButton01.grab_focus()

func _on_LevelButton01_pressed():
	get_tree().change_scene("res://gameplay/Level01_Square4By4.tscn")

func _on_LevelButton02_pressed():
	get_tree().change_scene("res://gameplay/Level02_RingOf13.tscn")

func _on_LevelButton03_pressed():
	get_tree().change_scene("res://gameplay/Level03_RoadShapeTOf22.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene("res://menus/StartMenu.tscn")
