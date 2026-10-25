extends Node2D
class_name Dubois

@onready var sprite : Sprite2D = find_child("Sprite")

var inPos = Vector2(266.0, 113.0)
var outPos = Vector2(392.0, 113.0)

var activePos = Vector2(266.0, 113.0)
var menuPos = Vector2(592.0, 113.0)

func _ready() -> void:
	Ref.mainMenu.menuClosed.connect(mainMenuClosed)
	Ref.mainMenu.menuOpened.connect(mainMenuOpened)

func mainMenuClosed():
	#Ref.dublingManager.canChangeMovement = false
	#
	#await speakWords("Hello! Its me Dubois! The great and mighty")
	#await speakWords("I have brought you here for ONE specific purpose mortal")
	#
	#await speakWords("To procure me an ARMY of dublings!")
	#await speakWords("And you have to do my bidding because i CONTROL this realm, ya hear")
	#
	#await speakWords("You may be wondering, whats a dubling? Well")
	#
	var tutDub : Dubling = Ref.dublingManager.createDubling()
	#
	#await speakWords("THIS is a spectacular dubling")
	#
	#await speakWords("They come from that really cool pipe I made! but theyre not free")
	#await speakWords("Ya gotta spend your shweckles to make one.")
	#await speakWords("Whats a shweckle?")
	#
	#Ref.shweckleManager.createShweckle("blue", Vector2(tutDub.global_position.x,  -195.0))
	#
	#await speakWords("Damn you really ARE new here, they tend to rain from the sky every now and then")
	#
	#await speakWords("Dublings LOVE shweckles and will happily collect them for you.")
	#await speakWords("Now, about the dublings, they tend to get quite lazy just give em 3 shweckles")
	#
	#tutDub.beLazy(false)
	#await tutDub.recharged
	#
	#await speakWords("As well as being currency, shweckles are quite tasty!")
	#await speakWords("Dublings are simple creatures and have 2 different controllable states.")
	#
	#tutDub.changeState(tutDub.moveTypes.FreeMove)
	#await speakWords("Red hat for freely moving, they lose energy in this state")
	#
	#tutDub.changeState(tutDub.moveTypes.Idle)
	#await speakWords("Blue hat for no movement")
	#
	#Ref.dublingManager.canChangeMovement = true
	#
	#await speakWords("And you can click on em to cycle between these")
	#
	#await speakWords("Anyways down to business.")
	#await speakWords("You're not off the hook")
	#await speakWords("See that clock up there?")
	#await speakWords("Upon striking the top i shall return")
	#await speakWords("I will demand a certain number of dublings to be sacraficed")
	#await speakWords("I hope you'll do the right thing.")

	Ref.shweckleManager.rainState(true)
	for i : Dubling in Ref.dublingManager.dublings:
		i.recharge()
	
	await demandQuota(100)
	leave()
	
func mainMenuOpened():
	pass
	
var deltaTimer = 0.0
func _process(delta: float) -> void:
	deltaTimer += delta
	sprite.position.y = sin(deltaTimer)*2

@onready var moveTween = create_tween()
func leave():
	Ref.judgement = false
	Ref.shweckleManager.rainState(true)
	moveTween.kill()
	moveTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)

	moveTween.tween_property(self, "position", outPos, 1)
	
	Ref.clockDisplay.returnText()
	
	for i in Ref.dublingManager.dublings:
		await get_tree().create_timer(randf_range(0.02, 0.06)).timeout
		i.recharge()

func comeBack():
	Ref.judgement = true
	moveTween.kill()
	moveTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	
	moveTween.tween_property(self, "position", inPos, 1)
	
	Ref.shweckleManager.rainState(false)
	

	Ref.showPopup("FREEZE", Color("4fd2f6"), Color("3674b3"))

	await moveTween.finished
	
	await speakWords("Alrighty lets see how you did.")
	await Ref.clockDisplay.centraliseText()
	
	evaluate()

func evaluate():
	var passed = Ref.dublingManager.dublings.size() >= Ref.currentQuota
	
	if passed:
		Ref.showPopup("PASSED", Color("278749"), Color("104a2e"))
		await speakWords("Yay! You got me my precious Dublings!")
		await speakWords("Ill take these off your hands now")
		
		Ref.dublingManager.take(Ref.currentQuota)
		
		await speakWords("Pleasure doing business with you")
		demandQuota(Ref.currentQuota + 1)
		
	else:
		Ref.showPopup("FAILED", Color("911c34"), Color("4a0712"))
		Ref.clockDisplay.returnText()
		await speakWords("Uh oh.. You didnt fulfill my demand")
		await speakWords("Im so sorry, this is kinda sad")
		await speakWords("I liked you i think")
		await speakWords("Oh well!")
		
		Ref.mainMenu.openMenu()

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
	Ref.currentQuota = count
	await speakWords("I demand you procure me " + str(Ref.currentQuota) + " Dublings")
	
	Ref.clockDisplay.tickClock(5)
	leave()
