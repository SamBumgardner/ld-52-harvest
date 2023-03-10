extends Button

export var level_index = 0
export var level_name = ""
onready var stars_earned_progress = $StarsEarned as TextureProgress
onready var high_score_label = $HighScore as Label

func _ready():
	text = level_name
	var level_score = HighScoreMemory.level_scores[level_index]
	stars_earned_progress.value = level_score.stars_earned
	
	high_score_label.text = \
		str(level_score.high_score) if level_score.high_score > 0 else ""
