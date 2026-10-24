extends Node2D
class_name ShweckleManager

var shewckles : Array[Shweckle] = []

@onready var spawnTimer : Timer = find_child("SpawnTimer")

var raining = false
var fallMult = 1.0

func _ready() -> void:
	spawnTimer.timeout.connect(spawnTimeout)
	
func createShweckle(id, overwritePos = null):
	var newShweckle : Shweckle = load("res://sprites/shweckles/shweckle.tscn").instantiate()
	
	var newPos = Vector2(randf_range(-300.0, 200.0), -195.0)
	
	add_child(newShweckle)
	
	newShweckle.loadData(id)
	
	shewckles.append(newShweckle)
	
	if overwritePos == null:
		newShweckle.global_position = newPos
	else:
		newShweckle.global_position = overwritePos
	
	return newShweckle

func spawnTimeout():
	if raining:
		var newS = createShweckle(Ref.shweckleData.keys().pick_random())
		
@onready var moveTween = create_tween()
func rainState(state):
	var finalFall = 0.0
	if state:
		finalFall = 1.0
	if moveTween:
		moveTween.kill()
	moveTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	moveTween.tween_property(self, "fallMult", finalFall, 1)
	raining = state
	
