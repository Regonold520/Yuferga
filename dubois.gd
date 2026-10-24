extends Node2D
class_name Dubois

@onready var sprite : Sprite2D = find_child("Sprite")

func _ready() -> void:
	Ref.dublingManager.canChangeMovement = false
	
	await speakWords("Hello! Its me Dubois! The great and mighty")
	await speakWords("I have brought you here for ONE specific purpose mortal")
	
	await speakWords("To procure me an ARMY of dublings!")
	await speakWords("And you have to do my bidding because i CONTROL this realm, ya hear")
	
	await speakWords("You may be wondering, whats a dubling? Well")
	
	var tutDub : Dubling = Ref.dublingManager.createDubling()
	
	await speakWords("THIS is a spectacular dubling")
	
	await speakWords("They come from that really cool pipe I made! but theyre not free")
	await speakWords("Ya gotta spend your shweckles to make one.")
	await speakWords("Whats a shweckle?")
	
	Ref.shweckleManager.createShweckle("blue", Vector2(tutDub.global_position.x,  -195.0))
	
	await speakWords("Damn you really ARE new here, they tend to rain from the sky every now and then")
	
	await speakWords("Dublings LOVE shweckles and will happily collect them for you.")
	await speakWords("Now, about the dublings, they tend to get quite lazy just give em 3 shweckles")
	
	tutDub.beLazy(false)
	await tutDub.recharged
	
	await speakWords("As well as being currency, shweckles are quite tasty!")
	await speakWords("Dublings are simple creatures and have 2 different controllable states.")
	
	tutDub.changeState(tutDub.moveTypes.FreeMove)
	await speakWords("Red hat for freely moving, they lose energy in this state")
	
	tutDub.changeState(tutDub.moveTypes.Idle)
	await speakWords("Blue hat for no movement")
	
	Ref.dublingManager.canChangeMovement = true
	
	await speakWords("And you can click on em to cycle between these")
	
	await speakWords("Anyways down to business.")
	await speakWords("You're not off the hook")
	await speakWords("See that clock up there?")
	await speakWords("Upon striking the top i shall return")
	await speakWords("I will demand a certain number of dublings to be sacraficed")
	await speakWords("I hope you'll do the right thing.")

	Ref.shweckleManager.raining = true
	for i : Dubling in Ref.dublingManager.dublings:
		i.recharge()
	
	await demandQuota(1)
	#leave()
	
var deltaTimer = 0.0
func _process(delta: float) -> void:
	deltaTimer += delta
	sprite.position.y = sin(deltaTimer)*2

@onready var txtTween = create_tween()
func speakWords(text):
	
	
	var txt : RichTextLabel = $Text
	
	txt.text = text
	
	txt.visible_characters = 0
	
	for i in text:
		txt.visible_characters += 1
		txtTween.kill()
		txtTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		
		
		var adder = 0
		if i in [".", ",", "?", "!"]: adder += 0.4
		
		var finalTime = 0.07 + adder
		
		txtTween.tween_property(sprite, "rotation_degrees", randf_range(-2, 2), finalTime )
		
		await get_tree().create_timer(finalTime).timeout
	txtTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	txtTween.tween_property(sprite, "rotation_degrees", 0, 0.3)
	await get_tree().create_timer(1).timeout
	
	txt.visible_characters = 0

func demandQuota(count):
	Ref.currentQuota += 1
	await speakWords("I demand you procure me " + str(Ref.currentQuota) + " Dublings")
	
	Ref.clockDisplay.tickClock(60)
