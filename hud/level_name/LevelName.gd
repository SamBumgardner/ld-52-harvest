extends Label


const DURATION = 3
const GRACE_PERIOD = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeAwayTimer.start(3)

func _process(_delta):
	var time_remaining = $FadeAwayTimer.time_left
	self_modulate = Color(1, 1, 1, 
		1 - (0 if time_remaining > DURATION - GRACE_PERIOD else (DURATION - time_remaining) / DURATION))

func _on_FadeAwayTimer_timeout():
	visible = false
