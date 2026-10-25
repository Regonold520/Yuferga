extends Node2D
class_name MenuDublings

var dublings = []

var activePos = Vector2(0.0, 500.0)
var menuPos = Vector2(0.0, 0.0)

func _ready() -> void:
	
	
	for i in 10:
		var newDub : Dubling = makeMenuDubling()
		newDub.collision_layer = 3
		newDub.collision_mask = 4
		newDub.getTired = false
		newDub.input_pickable = false
		newDub.changeState(newDub.moveTypes.FreeMove)
		newDub.sprite.texture = load("res://sprites/dubling.png")

func makeMenuDubling():
	var newDubling = load("res://dubling.tscn").instantiate()
	
	add_child(newDubling)
	
	dublings.append(newDubling)
	
	return newDubling

func _process(delta: float) -> void:
	pass
