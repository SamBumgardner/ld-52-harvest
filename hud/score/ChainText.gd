extends Label

const CROP_CHAIN_COLORS = [Color.white, Color.aliceblue, Color.aquamarine, Color.aqua, 
	Color.cornflower, Color.darkorchid, Color.red]

func _on_ScoreDisplay_crop_chain_changed(crop_chain, crop_chain_type):
	if crop_chain == 0:
		text = ""
	else:
		text = crop_chain_type + " chain " + str(crop_chain)
		add_color_override("font_color", CROP_CHAIN_COLORS[min(crop_chain, CROP_CHAIN_COLORS.size() - 1)])
