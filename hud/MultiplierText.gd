extends Label

const MULTIPLIER_COLORS = [Color.white, Color.aliceblue, Color.aquamarine, Color.aqua, 
	Color.cornflower, Color.plum, Color.darkorchid, Color.red]

var current_multiplier = 1

func _on_ScoreDisplay_multiplier_changed(new_multiplier):
	text = "x" + str(new_multiplier)
	add_color_override("font_color", MULTIPLIER_COLORS[new_multiplier - 1])
	current_multiplier = new_multiplier
