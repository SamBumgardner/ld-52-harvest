extends Node

export var TOTAL_LEVEL_COUNT = 3
var level_scores = []

func _ready():
	for i in TOTAL_LEVEL_COUNT:
		level_scores.append(LevelScore.new())

func _on_score_tally_complete(score, star_count, level_index):
	var old_scores = level_scores[level_index]
	old_scores.stars_earned = max(old_scores.stars_earned, star_count)
	old_scores.high_score = max(old_scores.high_score, score)

class LevelScore:
	var stars_earned:int = 0
	var high_score:int = 0
