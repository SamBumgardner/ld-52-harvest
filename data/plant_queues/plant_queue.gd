extends Resource

class_name PlantQueue

export var star_score_thresholds = [15000, 45000, 65000]
export var crops:Array = ["Corn", "Potato", "Corn"]
export var counts:Array = [5, 5, 5] 
var crops_data = preload("res://data/crops/crops_data.tres")
