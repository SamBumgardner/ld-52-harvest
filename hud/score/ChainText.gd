extends Label

const CROP_CHAIN_COLORS = [Color.WHITE, Color.ALICE_BLUE, Color.AQUAMARINE, Color.AQUA, 
	Color.cornflower, Color.DARK_ORCHID, Color.RED]

func _on_ScoreDisplay_crop_chain_changed(crop_chain, crop_chain_type):
	if crop_chain == 0:
		text = ""
	else:
		text = crop_chain_type + " chain " + str(crop_chain)
		add_theme_color_override("font_color", CROP_CHAIN_COLORS[min(crop_chain, CROP_CHAIN_COLORS.size() - 1)])
