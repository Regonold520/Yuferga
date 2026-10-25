extends Node2D
class_name SoundManager

func playAudio(audioPath, volume = 1, pitchChange = false):
	var newAudio : SoundObj = load("res://sound_obj.tscn").instantiate()
	
	add_child(newAudio)
	
	newAudio.volume_db = volume
	if pitchChange:
		newAudio.pitch_scale = randf_range(0.9,1.1)
	
	newAudio.start(load(audioPath))
