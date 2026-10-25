extends Button
class_name StartButton

var activePos = Vector2(-20.0, -400.0)
var menuPos = Vector2(-20.0, 10.0)

@onready var rotTween = create_tween()
func _on_mouse_entered() -> void:
	var newRot = [randf_range(-15, -5),randf_range(5, 15)].pick_random()
	
	rotTween.kill()
	rotTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	rotTween.tween_property(self, "rotation_degrees", newRot, 0.3)


func _on_mouse_exited() -> void:
	rotTween.kill()
	rotTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	rotTween.tween_property(self, "rotation_degrees", 0, 0.5)


func _on_pressed() -> void:
	Ref.mainMenu.closeMenu()
