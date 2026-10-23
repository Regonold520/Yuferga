extends Node2D
class_name Shweckle

@onready var sprite : Sprite2D = find_child("Sprite")

var id = null

var myData = null

var fallSpeed = 0.0
var value = 0.0

func loadData(newId):
	id = newId
	
	myData = Ref.shweckleData[newId]
	
	fallSpeed = myData["fallSpeed"]
	value = myData["value"]
	
	sprite.texture = load("res://sprites/shweckles/"+id+"_shweckle.png")
