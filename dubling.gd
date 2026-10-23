extends CharacterBody2D
class_name Dubling

const speed = 300.0
const JUMP_VELOCITY = -400.0

var targetX = null

enum moveTypes {Idle, FreeMove}
var currentMove = moveTypes.Idle

@onready var tickTimer : Timer = find_child("TickTimer")

func _ready() -> void:
	tickTimer.timeout.connect(tick)
	
	var newX = randf_range(-100, 100)
	
	targetX = newX

func tick():
	if !targetX:
		var newX = randf_range(-300, 200)
		targetX = newX

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if targetX and currentMove == moveTypes.FreeMove:
		var pos = Vector2(targetX, 156.0)
		velocity.x = (global_position.direction_to(pos) * (min(speed * delta,global_position.distance_to(pos)) / delta)).x
		if global_position.distance_to(pos) < 2:
			targetX = null
			velocity.x = 0

	
	
	move_and_slide()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			currentMove = wrap(currentMove + 1, 0, moveTypes.size())
			print(currentMove)
			
