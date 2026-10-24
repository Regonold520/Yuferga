extends CharacterBody2D
class_name Dubling

const speed = 200.0
const JUMP_VELOCITY = -400.0

var targetX = null

enum moveTypes {Idle, FreeMove, Rest}
var currentMove = moveTypes.Idle

var energy : float = 0.0
var maxEnergy : float = 100.0

@onready var tickTimer : Timer = find_child("TickTimer")
@onready var rechargeTimer : Timer = find_child("RechargeTimer")

@onready var sprite : Sprite2D = find_child("Sprite")

var isHovering = false
var start = true

var beforeRest : moveTypes

signal recharged

func _ready() -> void:
	energy = maxEnergy
	tickTimer.timeout.connect(tick)
	rechargeTimer.timeout.connect(recharge)
	
	var newX = randf_range(-100, 100)
	
	targetX = newX

func recharge():
	if currentMove == moveTypes.Rest:
		recharged.emit()
		rechargeTimer.stop()
		changeState(beforeRest)
		energy = maxEnergy

func beLazy(manualRecover = true):
	beforeRest = currentMove
	currentMove = moveTypes.Rest
	sprite.texture = load("res://sprites/dubling_green.png")
	
	if manualRecover:
		rechargeTimer.wait_time = randf_range(7.5, 12.5)
		rechargeTimer.start()

func changeState(newState : moveTypes):
	currentMove = newState
	if newState == moveTypes.Idle:
		sprite.texture = load("res://sprites/dubling.png")
	elif newState == moveTypes.FreeMove:
		sprite.texture = load("res://sprites/dubling_red.png")

func tick():
	if !targetX:
		var newX = randf_range(-300, 200)
		targetX = newX

func _physics_process(delta: float) -> void:
	isHovering = Ref.dublingManager.currentHover == self
	
	sprite.offset.y = -sprite.texture.get_height()/2
	
	if start and is_on_floor():
		start = false
	
	if currentMove == moveTypes.FreeMove:
		energy -= delta*5
	
	if isHovering:
		if Input.is_action_just_released("Click"):
			if currentMove != moveTypes.Rest and Ref.dublingManager.canChangeMovement:
				if currentMove == moveTypes.Idle:
					changeState(moveTypes.FreeMove)
				elif currentMove == moveTypes.FreeMove:
					changeState(moveTypes.Idle)
			else:
				if Ref.shweckleCount > 2:
					Ref.shweckleCount -= 3
					recharge()
		sprite.scale = Vector2(1.2,1.2)
	else:
		sprite.scale = Vector2(1,1)
	
	if energy <= 0 and currentMove != moveTypes.Rest:
		beLazy()
		
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var closest = null
	for i in Ref.shweckleManager.shewckles:
		if closest == null:
			closest = i
		else:
			if global_position.distance_to(i.global_position) < global_position.distance_to(closest.global_position):
				closest = i
	if !start:
		if !isHovering:
			if closest and currentMove != moveTypes.Rest:
				if global_position.distance_to(closest.global_position) < 80 and is_on_floor():
					velocity.y = JUMP_VELOCITY
			
			if targetX and currentMove == moveTypes.FreeMove:
				var pos = Vector2(targetX, 156.0)
				velocity.x = (global_position.direction_to(pos) * (min(speed * delta,global_position.distance_to(pos)) / delta)).x
				if global_position.distance_to(pos) < 5:
					targetX = null
					
					velocity.x = 0
			else:
				velocity.x = 0
		
	move_and_slide()

func _on_mouse_entered() -> void:
	var happened = Ref.dublingManager.hover(self)
	if happened:
		z_index = 1

func _on_mouse_exited() -> void:
	var happened = Ref.dublingManager.unhover(self)
	if happened:
		z_index = 0
