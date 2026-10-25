extends Sprite2D
class_name GameLogo

var activePos = Vector2(0.0, -341.0)
var menuPos = Vector2(0.0, -82.0)

var deltaTimer = 0.0
func _process(delta: float) -> void:
	deltaTimer += delta
	
	rotation_degrees = sin(deltaTimer*1.5)*3
	
	scale.x = 2 + sin(deltaTimer)/10
	scale.y = 2 + cos(deltaTimer/1.5)/8
