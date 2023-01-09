extends Control

func _ready():
	if $BackToLevelSelectButton/ExitLevelButton:
		$BackToLevelSelectButton/ExitLevelButton.grab_focus()
