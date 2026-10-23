extends Node2D
class_name ShweckleManager

var shewckles : Array[Shweckle] = []

@onready var spawnTimer : Timer = find_child("SpawnTimer")

func _ready() -> void:
	spawnTimer.timeout.connect(spawnTimeout)
	
	var s = createShweckle("green")
	
	s.global_position = Vector2(0,0)

func createShweckle(id):
	var newShweckle : Shweckle = load("res://sprites/shweckles/shweckle.tscn").instantiate()
	
	add_child(newShweckle)
	
	newShweckle.loadData(id)
	
	shewckles.append(newShweckle)
	
	return newShweckle

func spawnTimeout():
	var newPos = Vector2(randf_range(-300.0, 200.0), -195.0)
	
	var newS = createShweckle(Ref.shweckleData.keys().pick_random())
	
	newS.global_position = newPos
