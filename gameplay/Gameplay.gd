extends Node

class_name Gameplay

signal harvest_mode_change
signal level_ended

@export var plant_queue:Resource = preload("res://data/plant_queues/levels/placeholder.tres")
var harvest_cursor = preload("res://art/scythe.png")
var plant_cursor = preload("res://art/seed_satchel.png")

enum MOUSE_MODE {PLANT, HARVEST}
var mode = MOUSE_MODE.HARVEST

@onready var score_display = $ScoreDisplay as ScoreDisplay
@onready var plant_queue_display = $PlantQueueDisplay as PlantQueueDisplay
@onready var level_complete_overlay = $LevelCompleteOverlay
@onready var LevelName = $LevelName as Label
@onready var harvest_mode_symbol = $HarvestModeWebWorkaround as Sprite2D

@export var level_number = 0
@export var level_name = ""
var level_ended_detected_flag = false

func _ready():
	if LevelName:
		LevelName.text = level_name
	else:
		push_warning("Level name label node not found.")
	
	plant_queue_display.parent_ready()
	
	Input.set_custom_mouse_cursor(harvest_cursor, 0, Vector2(32, 0))
	
	connect("level_ended", Callable(level_complete_overlay, "_on_level_ended"))
	level_complete_overlay.connect("score_tally_complete", Callable(HighScoreMemory, "_on_score_tally_complete"))
	
	for child in $Field.get_children():
		connect("harvest_mode_change", Callable(child, "_on_harvest_mode_change"))
		
		(child as HarvestTile).connect_all_tile_events(score_display)
		(child as HarvestTile).connect("tile_planted", Callable(plant_queue_display, "_on_tile_planted"))
		
		plant_queue_display.connect("crop_change", Callable(child, "_on_crop_change"))
		(child as HarvestTile).planting_crop_type = plant_queue_display.get_current_crop()
	
	if $BackgroundMusic:
		$BackgroundMusic.play()
	else:
		push_warning("Level background music node not found.")
	
	_set_up_hacky_plant_queue()
	_web_cursor_workaround()

func _set_up_hacky_plant_queue():
	if not $HackyPlantQueue:
		push_warning("Level hacky plant queue node not found.")
		return
	
	var hackyQueueBadges = $HackyPlantQueue.get_children()
	for i in hackyQueueBadges.size():
		if i < plant_queue.crops.size():
			hackyQueueBadges[i].set_sprite_offset(plant_queue.crops_data.crops[plant_queue.crops[i]].badge_index_offset)
			hackyQueueBadges[i].set_crop_count(plant_queue.counts[i])
		else:
			hackyQueueBadges[i].visible = false

func _web_cursor_workaround():
	if not harvest_mode_symbol:
		push_warning("Level harvest mode web workaround node not found.")
		return
	
	if (OS.get_name() == "HTML5"):
		harvest_mode_symbol.visible = true
		harvest_mode_symbol.frame = mode
	else:
		harvest_mode_symbol.visible = false

func _process(_delta):
	_check_harvest_mode_toggle()
	_check_level_ended()

func _check_harvest_mode_toggle():
	if Input.is_action_just_pressed("harvest_mode_toggle"):
		if mode == MOUSE_MODE.PLANT:
			mode = MOUSE_MODE.HARVEST
			Input.set_custom_mouse_cursor(harvest_cursor, 0, Vector2(32, 0))
			
		else:
			mode = MOUSE_MODE.PLANT
			Input.set_custom_mouse_cursor(plant_cursor, 0, Vector2(32, 0))
		
		if harvest_mode_symbol:
			harvest_mode_symbol.frame = mode
		
		emit_signal("harvest_mode_change", mode)

func _check_level_ended():
	if plant_queue_display.get_current_crop().is_empty() && !level_ended_detected_flag:
		var no_active_plants = true
		for child in $Field.get_children():
			no_active_plants = no_active_plants and (child as HarvestTile).is_empty()
		
		if no_active_plants:
			level_ended_detected_flag = true
			$BackgroundMusic.stop()
			emit_signal("level_ended", score_display.score, plant_queue.star_score_thresholds, 
				HighScoreMemory.level_scores[level_number].high_score, level_number)
