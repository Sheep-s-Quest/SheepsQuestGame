extends Node

var game_paused = false
@onready var pause_menu = $CanvasLayer/PauseMenu


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_play_pressed()
	
	if game_paused == true:
		get_tree().paused = true
		pause_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	else:
		get_tree().paused = false
		pause_menu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_play_pressed():
	game_paused = !game_paused


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/ui_scenes/main_menu/main_menu.tscn")
