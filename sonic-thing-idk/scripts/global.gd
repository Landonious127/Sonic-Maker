extends Node

var paused: bool = false
var editor: bool = false

func _process(event):
	if Input.is_action_just_pressed("Pause"):
		paused = !paused
		print("Paused:", paused)
	
	if Input.is_action_just_pressed("Editor"):
		editor = !editor
		print("Editor:", editor)
