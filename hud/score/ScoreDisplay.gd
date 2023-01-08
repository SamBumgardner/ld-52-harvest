extends Node2D

class_name ScoreDisplay

signal multiplier_changed
signal crop_chain_changed
signal final_score

const RIPE_GROWTH_STAGE = 4
const MAX_MULTIPLIER = 8
const DIFFICULT_MULTIPLIER_START = 5
const COMBO_GROWTH_THRESHOLDS = [0.0, 50.0, 150.0, 450.0, 1000.0, 1600.0, 2200.0, 2800.0]
const COMBO_TIMER_DURATIONS = [10, 10, 10, 10, 8, 6, 4, 4]
const COMBO_TIMER_GRACE_DURATION = [2, 2, 1, 1, 1, 1, .5, .5]
const PLANT_GRACE_DURATION = .25
const MAX_PLANT_GRACE_COUNT = 8
const MAX_CROP_CHAIN_BONUS = 5
const CROP_CHAIN_GROWTH_VALUES = [2, 4, 8, 16, 32, 64]

var score = 0

var crop_chain_type = ""
var crop_chain = 0
var combo_growth_max = COMBO_GROWTH_THRESHOLDS[1]
var combo_growth_current = 0
var multiplier = 1
var plants_since_last_harvest = 0

onready var chain_text = $ChainText as Label
onready var multiplier_text = $MultiplierText as Label
onready var score_text = $ScoreText as Label
onready var grace_timer = $GraceTimer as Timer
onready var combo_timer = $ComboTimer as Timer
onready var combo_timer_display = $ComboTimerDisplay as ProgressBar
onready var combo_growth = $ComboGrowth as ProgressBar

func _on_tile_planted(_crop_type):
	if (plants_since_last_harvest < MAX_PLANT_GRACE_COUNT - multiplier):
		_start_grace_timer(PLANT_GRACE_DURATION)
	plants_since_last_harvest += 1

func _on_tile_harvested(crop_type, growth_stage, base_score):
	_increase_score(base_score)
	_increase_combo_growth(crop_type, growth_stage)
	_check_combo_growth()
	_update_combo_timer(growth_stage)
	plants_since_last_harvest = 0

func _increase_score(base_score):
	score += base_score * multiplier
	score_text.text = str(score)

func _increase_combo_growth(crop_type, growth_stage):
	if crop_type != crop_chain_type:
		crop_chain = 0
		crop_chain_type = crop_type
	
	if multiplier < MAX_MULTIPLIER:
		combo_growth_current += CROP_CHAIN_GROWTH_VALUES[min(crop_chain, MAX_CROP_CHAIN_BONUS)] \
			* 2 if growth_stage == RIPE_GROWTH_STAGE else 1
		combo_growth.value = combo_growth_current / combo_growth_max * 100
	
	crop_chain += 1
	emit_signal("crop_chain_changed", crop_chain, crop_chain_type)

func _check_combo_growth():
	if multiplier < MAX_MULTIPLIER \
			&& combo_growth_current >= COMBO_GROWTH_THRESHOLDS[multiplier]:
		_upgrade_multiplier()
		_update_combo_threshold()

func _upgrade_multiplier():
	combo_growth_current -= COMBO_GROWTH_THRESHOLDS[multiplier]
	multiplier += 1
	emit_signal("multiplier_changed", multiplier)

func _update_combo_threshold():
	if multiplier < MAX_MULTIPLIER:
		combo_growth_max = COMBO_GROWTH_THRESHOLDS[multiplier]
		combo_growth.value = combo_growth_current / combo_growth_max * 100

func _update_combo_timer(growth_stage):
	if multiplier < DIFFICULT_MULTIPLIER_START or growth_stage == RIPE_GROWTH_STAGE:
		combo_timer.start(COMBO_TIMER_DURATIONS[multiplier - 1])
	_start_grace_timer(COMBO_TIMER_GRACE_DURATION[multiplier - 1])

func _start_grace_timer(duration):
	combo_timer.paused = true
	grace_timer.start(duration)

func _on_GraceTimer_timeout():
	combo_timer.paused = false

func _on_ComboTimer_timeout():
	crop_chain = 0
	crop_chain_type = ""
	emit_signal("crop_chain_changed", crop_chain, crop_chain_type)
	
	if (multiplier > 1):
		multiplier -= 1
	combo_growth_current = 0
	combo_growth_max = COMBO_GROWTH_THRESHOLDS[multiplier]
	combo_growth.value = 0
	emit_signal("multiplier_changed", multiplier)
	if(multiplier > 1):
		combo_timer.start(COMBO_TIMER_DURATIONS[multiplier - 1])

func _process(_delta):
	_update_combo_timer_display()

func _update_combo_timer_display():
	combo_timer_display.value = combo_timer.time_left / combo_timer.wait_time * 100
