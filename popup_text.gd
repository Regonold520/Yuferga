extends RichTextLabel
class_name PopupText

func _ready() -> void:
	position = Vector2(-192.0, -20.0)
	
	scale = Vector2(0.2,0.2)
	modulate = Color(1,1,1,1.0)

func present(newText : String, baseColour : Color, outlineColour : Color):
	var textTween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel()
	
	add_theme_color_override("default_color", baseColour)
	add_theme_color_override("font_outline_color", outlineColour)
	
	text = newText
	
	textTween.tween_property(self, "scale", Vector2(1.2,1.2), 1.3)
	textTween.tween_property(self, "modulate", Color(1,1,1,0.0), 0.8).set_delay(0.5)
	
	await textTween.finished
	
	queue_free()
