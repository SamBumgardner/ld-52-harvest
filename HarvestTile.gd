extends Area2D

class_name HarvestTile

signal tile_harvested

const MAX_GROWTH_STAGE = 5
const HARVESTABLE_GROWTH_STAGES = [4, 5, 6]

enum MOUSE_MODE {PLANT, HARVEST}
var mode = MOUSE_MODE.PLANT
var mouse_hovering = false

var growing = false;
var growth_stage = 0;

func _ready():
	pass # Replace with function body.

func _on_harvest_mode_change(newMode):
	mode = newMode
	if mouse_hovering:
		_mouse_action()

func _on_mouse_entered():
	mouse_hovering = true
	_mouse_action()

func _on_HarvestTile_mouse_exited():
	mouse_hovering = false
	
func _mouse_action():
	match mode:
		MOUSE_MODE.PLANT:
			_plant()
		MOUSE_MODE.HARVEST:
			_harvest()
	
func _plant():
	if !growing:
		growing = true
		_grow()
		$Growth.start(1)

func _harvest():
	if growing && growth_stage in HARVESTABLE_GROWTH_STAGES:
		print("harvested during growth stage: ", growth_stage)
		emit_signal("tile_harvested")
		_remove_plant()

func _on_Growth_timeout():
	if growth_stage < MAX_GROWTH_STAGE:
		_grow()
	else:
		_die()
		
func _grow():
	growth_stage += 1
	$Sprite.frame += 1

func _die():
	_remove_plant()

func _remove_plant():
	$Sprite.frame = 0
	growth_stage = 0
	$Growth.stop()
	growing = false
