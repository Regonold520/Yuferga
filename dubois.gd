extends Node2D

@onready var sprite : Sprite2D = find_child("Sprite")

func _ready() -> void:
	speakWords("Hello! Its me Dubois! The great and mighty")

var deltaTimer = 0.0
func _process(delta: float) -> void:
	deltaTimer += delta
	sprite.position.y = sin(deltaTimer)*2

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
