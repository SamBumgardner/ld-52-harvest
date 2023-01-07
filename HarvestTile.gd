extends Area2D

class_name HarvestTile

signal tile_harvested

const MAX_GROWTH_STAGE = 5
const HARVESTABLE_GROWTH_STAGES = [3, 4, 5]

var CROP_DATA = preload("res://data/crops_data.tres")

var planting_crop_type = "corn"

enum MOUSE_MODE {PLANT, HARVEST}
var mode = MOUSE_MODE.PLANT
var mouse_hovering = false

var growing = false;
var crop = "";
var growth_stage = 0;

func _ready():
	_select_random_crop()

func _select_random_crop():
	randomize()
	planting_crop_type = CROP_DATA.crops.keys()[randi() % CROP_DATA.crops.size()]

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
		crop = planting_crop_type
		_grow()
		$Growth.start(CROP_DATA.crops[crop].growth_times[growth_stage - 1])

func _harvest():
	if growing && growth_stage in HARVESTABLE_GROWTH_STAGES:
		emit_signal("tile_harvested", crop, CROP_DATA.crops[crop].scores[growth_stage - 1])
		print("scored ", crop, " at growth stage ", growth_stage, " for ", 
			CROP_DATA.crops[crop].scores[growth_stage - 1], " points")
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
