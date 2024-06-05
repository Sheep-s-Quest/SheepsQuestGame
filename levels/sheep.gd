extends Node2D

@onready var anim_player = $AnimationPlayer

func _physics_process(delta):
	anim_player.play("idle")
