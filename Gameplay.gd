extends Node

class_name Gameplay

signal harvest_mode_change

var plant_queue:PlantQueue = preload("res://data/plant_queues/levels/gameplay_test_queue.tres")
var harvest_cursor = preload("res://art/scythe.png")
var plant_cursor = preload("res://art/seed_satchel.png")

enum MOUSE_MODE {PLANT, HARVEST}
var mode = MOUSE_MODE.HARVEST

onready var score_display = $ScoreDisplay as ScoreDisplay
onready var plant_queue_display = $PlantQueueDisplay as PlantQueueDisplay

func _ready():
	Input.set_custom_mouse_cursor(harvest_cursor, 0, Vector2(32, 0))
	
	for child in $Field.get_children():
		connect("harvest_mode_change", child, "_on_harvest_mode_change")
		
		(child as HarvestTile).connect_all_tile_events(score_display)
		(child as HarvestTile).connect("tile_planted", plant_queue_display, "_on_tile_planted")
		
		plant_queue_display.connect("crop_change", child, "_on_crop_change")
		(child as HarvestTile).planting_crop_type = plant_queue_display.get_current_crop()

func _process(_delta):
	if Input.is_action_just_pressed("harvest_mode_toggle"):
		if mode == MOUSE_MODE.PLANT:
			mode = MOUSE_MODE.HARVEST
			Input.set_custom_mouse_cursor(harvest_cursor, 0, Vector2(32, 0))
		else:
			mode = MOUSE_MODE.PLANT
			Input.set_custom_mouse_cursor(plant_cursor, 0, Vector2(32, 0))
		emit_signal("harvest_mode_change", mode)
