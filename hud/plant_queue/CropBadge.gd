extends Sprite

class_name CropBadge

onready var countLabel = $Count as Label

func set_sprite_offset(offset):
	frame = offset

func set_crop_count(count):
	countLabel.text = str(count)
