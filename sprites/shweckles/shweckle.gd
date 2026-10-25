extends Node2D
class_name Shweckle

@onready var sprite : Sprite2D = find_child("Sprite")

var id = null

var myData = null

var fallSpeed = 0.0
var value = 0.0

@onready var rpv = randi()

func loadData(newId):
	id = newId
	
	myData = Ref.shweckleData[newId]
	
	sprite.flip_h = randi_range(0,1) == 1
	
	fallSpeed = myData["fallSpeed"]
	value = myData["value"]
	
	sprite.texture = load("res://sprites/shweckles/"+id+"_shweckle.png")

var deltaTimer = 0.0
func _process(delta: float) -> void:
	deltaTimer += delta
	position.y += ((delta*30) * fallSpeed)*Ref.shweckleManager.fallMult
	
	sprite.rotation_degrees = sin((deltaTimer+rpv)*5)*5
	
	if position.y > 210.0:
		Ref.shweckleManager.shewckles.erase(self)
		queue_free()

var disabled = false
func _on_body_entered(body: Node2D) -> void:
	if body is Dubling:
		if body.currentMove != body.moveTypes.Rest and !disabled:
			var audio = ["nom1", "nom2", "nom3"].pick_random()
			Ref.soundManager.playAudio("res://audio/"+audio+".mp3", -1, true)
			
			
			disabled = true
			print("yolo", self)
			Ref.shweckleCount += value
			Ref.shweckleManager.shewckles.erase(self)
			queue_free()
