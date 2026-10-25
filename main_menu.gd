extends Node2D
class_name MainMenu

var movers = []

signal menuClosed
signal menuOpened

func _ready() -> void:
	movers = [Ref.clockDisplay, Ref.shweckleDisplay, Ref.dublingPipe, Ref.dubois]
	for i in movers:
		i.position = i.menuPos
		
	await openMenu()
	
@onready var moveTween = create_tween()

func openMenu():
	menuOpened.emit()
	moveTween.kill()
	moveTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	
	for i in movers:
		moveTween.tween_property(i, "position", i.menuPos, 1)
	
	await get_tree().create_timer(0.5).timeout
	
	get_tree().paused = true  
	
	await get_tree().create_timer(2).timeout
	
	closeMenu()
	
func closeMenu():
	moveTween.kill()
	moveTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	
	for i in movers:
		moveTween.tween_property(i, "position", i.activePos, 0.5)
	await moveTween.finished
	
	get_tree().paused = false
	menuClosed.emit()
