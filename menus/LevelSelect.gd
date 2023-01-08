extends Control

func _ready():
	Input.set_custom_mouse_cursor(null, CURSOR_ARROW)
	$ButtonsContainer/LevelButton00.grab_focus()
	for button in $ButtonsContainer.get_children():
		var level_suffix = str(button.level_index) if button.level_index > 9 else "0" + str(button.level_index)
		button.connect("pressed", self, "_on_LevelButton_pressed", [level_suffix])

func _on_LevelButton_pressed(level_suffix):
	get_tree().change_scene("res://gameplay/levels/Level_" + level_suffix + ".tscn")
