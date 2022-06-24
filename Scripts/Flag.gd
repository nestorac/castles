extends Spatial

signal flag_placed(flag_node)
signal flag_removed

onready var units_position = $"UnitsPositions"
var positions = []

func _ready():
	for position_node in units_position.get_children():
		positions.append(position_node)
