extends Node

class_name Gameplay

signal harvest_mode_change

enum MOUSE_MODE {PLANT, HARVEST}
var mode = MOUSE_MODE.PLANT


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $Field.get_children():
		connect("harvest_mode_change", child, "_on_harvest_mode_change")


	

func _process(delta):
	if Input.is_action_just_pressed("harvest_mode_toggle"):
		if mode == MOUSE_MODE.PLANT:
			mode = MOUSE_MODE.HARVEST
		else:
			mode = MOUSE_MODE.PLANT
		emit_signal("harvest_mode_change", mode)
