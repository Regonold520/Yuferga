extends Node2D
class_name DublingManager

var dublings : Array = []
		
var currentHover : Dubling = null

var canChangeMovement = true

func _ready() -> void:
	Ref.mainMenu.menuClosed.connect(mainMenuClosed)
	Ref.mainMenu.menuOpened.connect(mainMenuOpened)
	
func mainMenuClosed():
	return
	for i in 20:
		await get_tree().create_timer(0.01).timeout
		var d : Dubling = createDubling()
		d.changeState(d.moveTypes.FreeMove)

func mainMenuOpened():
	var endTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	for i in dublings.duplicate():
		endTween.tween_property(i, "position:y", 220.0, 0.5)
		endTween.tween_property(i, "modulate", Color(1,1,1,0), 0.5)
		dublings.erase(i)

func hover(newDub):
	if currentHover == null:
		currentHover = newDub
		return true
	return false
	
func unhover(newDub):
	if newDub == currentHover:
		currentHover = null
		return true
	return false

func take(count):
	var fullCount = dublings.duplicate()
	var collected = []
	
	for i in count:
		var picked = fullCount.pick_random()
		fullCount.erase(picked)
		collected.append(picked)
	
	for i in collected:
		i.ascend()
		dublings.erase(i)
		Ref.clockDisplay.setQuotaText()
		await get_tree().create_timer(randf_range(0.02, 0.06)).timeout

func createDubling():
	var newDubling : Dubling = load("res://dubling.tscn").instantiate()
	
	
	var spawnPos = Ref.dublingPipe.spawnPoint.global_position
	
	add_child(newDubling)
	
	dublings.append(newDubling)
	
	Ref.clockDisplay.setQuotaText()
	
	newDubling.currentMove = newDubling.moveTypes.Idle
	
	newDubling.position = spawnPos
	
	newDubling.velocity = Vector2(randf_range(-700, -300), 0)
	
	newDubling.scale = Vector2.ONE
	
	var scaleTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	scaleTween.tween_property(newDubling, "scale", Vector2(2.5,2.5), 1.0)
	
	return newDubling
