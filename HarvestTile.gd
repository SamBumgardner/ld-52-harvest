extends Area2D

class_name HarvestTile

signal tile_harvested
signal tile_planted

const MAX_GROWTH_STAGE = 5
const HARVESTABLE_GROWTH_STAGES = [3, 4, 5]

var CROP_DATA = preload("res://data/crops/crops_data.tres")

var planting_crop_type = "unset"

enum MOUSE_MODE {PLANT, HARVEST}
var mode = MOUSE_MODE.HARVEST
var mouse_hovering = false

var growing = false;
var crop = "";
var growth_stage = 0;

func connect_all_tile_events(target):
	connect("tile_harvested", target, "_on_tile_harvested")
	connect("tile_planted", target, "_on_tile_planted")

func _on_crop_change(new_crop):
	planting_crop_type = new_crop

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
	if !growing && !planting_crop_type.empty():
		growing = true
		crop = planting_crop_type
		emit_signal("tile_planted", crop)
		_grow()
		$Growth.start(CROP_DATA.crops[crop].growth_times[growth_stage - 1])

func _harvest():
	if growing && growth_stage in HARVESTABLE_GROWTH_STAGES:
		emit_signal("tile_harvested", crop, growth_stage, CROP_DATA.crops[crop].scores[growth_stage - 1])
		_remove_plant()

func _on_Growth_timeout():
	if growth_stage < MAX_GROWTH_STAGE:
		_grow()
		if mouse_hovering && mode == MOUSE_MODE.HARVEST:
			_harvest()
	else:
		_die()
		
func _grow():
	growth_stage += 1
	if growth_stage == 3:
		$Sprite.frame += CROP_DATA.crops[crop].sprite_index_offset
	$Sprite.frame += 1 
	$Growth.start(CROP_DATA.crops[crop].growth_times[growth_stage - 1])

func _die():
	_remove_plant()

func _remove_plant():
	$Sprite.frame = 0
	growth_stage = 0
	crop = ""
	$Growth.stop()
	growing = false
