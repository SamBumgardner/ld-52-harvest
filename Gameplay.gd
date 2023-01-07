extends Node

class_name Gameplay

signal harvest_mode_change

enum MOUSE_MODE {PLANT, HARVEST}
var mode = MOUSE_MODE.PLANT

onready var score_display = $ScoreDisplay as ScoreDisplay

func _ready():
	for child in $Field.get_children():
		connect("harvest_mode_change", child, "_on_harvest_mode_change")
		(child as HarvestTile).connect_tile_events(score_display)

func _process(_delta):
	if Input.is_action_just_pressed("harvest_mode_toggle"):
		if mode == MOUSE_MODE.PLANT:
			mode = MOUSE_MODE.HARVEST
		else:
			mode = MOUSE_MODE.PLANT
		emit_signal("harvest_mode_change", mode)
