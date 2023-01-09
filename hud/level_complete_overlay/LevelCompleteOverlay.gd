extends Popup

signal score_tally_complete

onready var score_label = $Panel/Score as Label
onready var star_progress = $Panel/StarProgress as TextureProgress
onready var next_star_label = $Panel/NextStar as Label

func _on_LevelSelectButton_pressed():
	get_tree().change_scene("res://menus/LevelSelect.tscn")

func _on_level_ended(score, star_thresholds, high_score, level_index):
	score_label.text = "Score:\n" + str(score)

	var total_stars = 0
	for threshold in star_thresholds:
		if threshold > score:
			next_star_label.text = "Next Star at:\n" + str(threshold)
			break
		total_stars += 1
	
	star_progress.value = total_stars * 100
	
	if total_stars == 3:
		if score > high_score:
			next_star_label.text = "New High Score!\n" + str(score)
		else:
			high_score.text = "High Score:\n" + str(high_score)
	
	emit_signal("score_tally_complete", score, total_stars, level_index)
	
	visible = true
	
