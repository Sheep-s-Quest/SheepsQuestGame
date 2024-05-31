class_name TntGoblin
extends RangeEnemy

func _ready():
	_init_detection_area()
	_init_health_system()
	_init_attack_system()

func _physics_process(_delta) -> void:
	match _current_state:
		ACTION_STATE.ATTACK:
			return
		_:
			_handle_default_state()
			_play_animation()
			print("Current state: ", ACTION_STATE.keys()[_current_state])

func _play_animation() -> void:
	match _current_state:
		ACTION_STATE.IDLE:
			if _is_sprite_flipped_h:
				animation_player.play("idle")
			else:
				animation_player.play("idle_flipped_h")	
		ACTION_STATE.WALK:
			if _is_sprite_flipped_h:
				animation_player.play("walk")
			else:
				animation_player.play("walk_flipped_h")
		ACTION_STATE.ATTACK:
			match _look_direction:
				LOOK_DIRECTION.RIGHT:
					animation_player.play("attack")
				LOOK_DIRECTION.LEFT:
					animation_player.play("attack_flipped_h")
				LOOK_DIRECTION.DOWN, LOOK_DIRECTION.UP:
					if _is_sprite_flipped_h:
						animation_player.play("attack_flipped_h")
					else:
						animation_player.play("attack")
		_:
			if _is_sprite_flipped_h:
				animation_player.play("idle")
			else:
				animation_player.play("idle_flipped_h")	
