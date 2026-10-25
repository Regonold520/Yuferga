extends AudioStreamPlayer2D
class_name SoundObj

func start(audio):
	stream = audio
	play()
	
func _on_finished() -> void:
	queue_free()
