extends Node2D
class_name ClockDisplay

var timePassed : float = 0.0
var tickTime : float =  1.0

@onready var txt : RichTextLabel = find_child("Text")

var textOrigPos = Vector2(-142.4, -9.2)
var textOrigRot = -10.6
var textOrigScale = Vector2(0.228,0.228)

var textCenterPos = Vector2(-44.4, -5.2)
var textCenterRot = 0.0
var textCenterScale = Vector2(0.368,0.368)

var activePos = Vector2(-267.0, -131.0)
var menuPos = Vector2(-400.0, -131.0)

func setQuotaText():
	var newStr = str(Ref.dublingManager.dublings.size()) + "/" + str(Ref.currentQuota)
	
	txt.text = newStr

@onready var textTween = create_tween() 
func centraliseText():
	var textTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	textTween.tween_property(txt, "position", textCenterPos, 1)
	textTween.tween_property(txt, "scale", textCenterScale, 1)
	textTween.tween_property(txt, "rotation_degrees", textCenterRot, 1)
	
	await textTween.finished

func returnText():
	var textTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	textTween.tween_property(txt, "position", textOrigPos, 1)
	textTween.tween_property(txt, "scale", textOrigScale, 1)
	textTween.tween_property(txt, "rotation_degrees", textOrigRot, 1)
	
	await textTween.finished

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
	clockChime()

func clockChime():
	Ref.dubois.comeBack()
	var hand : Sprite2D = find_child("Hand")
	Ref.dublingManager.canChangeMovement = false
	
	for i : Dubling in Ref.dublingManager.dublings:
		i.recharge()
		i.beLazy(false)
	
	handTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	handTween.tween_property(hand, "rotation_degrees", 360*3, 1)
	await handTween.finished
	hand.rotation_degrees = 0
