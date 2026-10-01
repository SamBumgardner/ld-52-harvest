extends Label

const MULTIPLIER_COLORS = [Color.WHITE, Color.ALICE_BLUE, Color.AQUAMARINE, Color.AQUA, 
	Color.CORNFLOWER_BLUE, Color.PLUM, Color.DARK_ORCHID, Color.RED]

var current_multiplier = 1

func _on_ScoreDisplay_multiplier_changed(new_multiplier):
	text = "x" + str(new_multiplier)
	add_theme_color_override("font_color", MULTIPLIER_COLORS[new_multiplier - 1])
	current_multiplier = new_multiplier
