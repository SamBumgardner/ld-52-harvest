extends Node2D

class_name PlantQueueDisplay

signal crop_change

export var plant_queue:Resource = preload("res://data/plant_queues/levels/gameplay_test_queue.tres")

onready var crops = plant_queue.crops
onready var counts = plant_queue.counts

onready var badge0 = $CropBadge0 as CropBadge
onready var badge1 = $CropBadge1 as CropBadge
onready var badge2 = $CropBadge2 as CropBadge
onready var badges = [badge0, badge1, badge2]

func _ready():
	_update_display()

func get_current_crop():
	return crops[0] if crops.size() > 0 else ""

func _on_tile_planted(_crop_type):
	counts[0] -= 1
	if counts[0] == 0:
		crops.pop_front()
		counts.pop_front()
		emit_signal("crop_change", crops[0] if crops.size() > 0 else "")
	_update_display()

func _update_display():
	for i in badges.size():
		if i < crops.size():
			badges[i].set_sprite_offset(plant_queue.crops_data.crops[crops[i]].badge_index_offset)
			badges[i].set_crop_count(counts[i])
		else:
			badges[i].visible = false
