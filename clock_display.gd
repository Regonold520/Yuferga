extends Node2D
class_name ClockDisplay

var timePassed : float = 0.0
var tickTime : float =  1.0

@onready var txt : RichTextLabel = find_child("Text")

func setQuotaText():
	var newStr = str(Ref.dublingManager.dublings.size()) + "/" + str(Ref.currentQuota)
	
	txt.text = newStr

@onready var handTween = create_tween()
func tickClock(seconds):
	var ticks = seconds / tickTime
	var hand : Sprite2D = find_child("Hand")
	
	for i in ticks+1:
		handTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		var newRot = (360/ticks)*i
		
		handTween.tween_property(hand, "rotation_degrees", newRot, 0.3)
		
		await get_tree().create_timer(tickTime).timeout
	hand.rotation_degrees = 0
	tickClock(20)
