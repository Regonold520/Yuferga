extends Node

var shweckleData : Dictionary

@onready var shweckleManager : ShweckleManager = get_tree().current_scene.find_child("ShweckleManager")
@onready var dublingManager : DublingManager = get_tree().current_scene.find_child("DublingManager")

@onready var shweckleDisplay : ShweckleDisplay = get_viewport().get_camera_2d().find_child("ShweckleDisplay")
@onready var clockDisplay : ClockDisplay = get_viewport().get_camera_2d().find_child("ClockDisplay")
@onready var dublingPipe : DublingPipe = get_viewport().get_camera_2d().find_child("DublingPipe")

@onready var dubois : Dubois = get_tree().current_scene.find_child("Dubois")

@onready var popupTextScene : PackedScene = load("res://popup_text.tscn")

var judgement = false

func showPopup(text : String, baseColour : Color, outlineColour : Color):
	var newPopup : PopupText = popupTextScene.instantiate()
	get_viewport().get_camera_2d().add_child(newPopup)
	
	newPopup.present(text, baseColour, outlineColour)

var shweckleCount : int = 2:
	set(count):
		shweckleCount = count
		shweckleDisplay.txt.text = "X" + str(count)
		shweckleDisplay.jiggle()

var currentQuota = 0:
	set(value):
		currentQuota = value
		clockDisplay.setQuotaText()

func _ready() -> void:
	shweckleData = parse_json_path("res://datastore/shweckleData.json")

func parse_json_path(path):
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var json_text := file.get_as_text()
		file.close()
		var result = JSON.parse_string(json_text)
		if result != null:
			var my_dict : Dictionary = result
			return my_dict
		else:
			push_error("Failed to parse JSON")
