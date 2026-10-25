extends Area2D
class_name DublingPipe

@onready var spawnPoint : Marker2D = find_child("SpawnPoint")

var canBuy = true

var isHovering = false

var activePos = Vector2(286.0, -90.0)
var menuPos = Vector2(400.0, -90.0)

var nextCost = 0:
	set(value):
		nextCost = value
		find_child("Text").text = "X" + str(value)

func _ready() -> void:
	nextCost = 3
	
func _process(delta: float) -> void:
	if isHovering and Input.is_action_just_released("Click") and !Ref.judgement and canBuy:
		if Ref.shweckleCount - nextCost >= 0:
			Ref.shweckleCount -= nextCost
			nextCost += 1
			Ref.dublingManager.createDubling()

@onready var pipeTween = create_tween()
func _on_mouse_entered() -> void:
	if !Ref.judgement:
		isHovering = true
		
		pipeTween.kill()
		pipeTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		pipeTween.tween_property(find_child("Popup"), "rotation_degrees", 0, 0.3)

func _on_mouse_exited() -> void:
	isHovering = false
	
	pipeTween.kill()
	pipeTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	pipeTween.tween_property(find_child("Popup"), "rotation_degrees", -90, 0.3)
