extends Node2D
class_name ShweckleManager

func _ready() -> void:
	var s = createShweckle("green")
	
	s.global_position = Vector2(0,0)

func createShweckle(id):
	var newShweckle : Shweckle = load("res://sprites/shweckles/shweckle.tscn").instantiate()
	
	add_child(newShweckle)
	
	newShweckle.loadData(id)
	
	return newShweckle
