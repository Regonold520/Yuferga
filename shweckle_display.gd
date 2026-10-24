extends Node2D
class_name ShweckleDisplay

@onready var img : Sprite2D = find_child("Shweckle")
@onready var txt : RichTextLabel = find_child("Text")

var deltaTimer : float = 0.0
func _process(delta: float) -> void:
	deltaTimer += delta
	
	img.rotation_degrees = sin(deltaTimer) * 10

@onready var jiggleTween = create_tween()
func jiggle():
	jiggleTween.kill()
	jiggleTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	
	var randScale = randf_range(1.2, 1.5)
	img.scale = Vector2(randScale,randScale)
	jiggleTween.tween_property(img, "scale", Vector2.ONE, 0.3)
