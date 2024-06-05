extends Node2D

@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("story")
	
func _process(delta):
	if(!anim_player.is_playing()):
		get_tree().change_scene_to_file("res://levels/test_level.tscn")
