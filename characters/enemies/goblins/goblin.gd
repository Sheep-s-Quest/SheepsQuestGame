class_name Goblin
extends Enemy

func _physics_process(_delta) -> void:
	if in_chase and player and is_alive:
		var direction = (player.position - position).normalized()
		velocity_component.move(direction)
	
		_current_state = ACTION_STATE.WALK
		_update_look_direction_to_point(direction)
	else:
		_current_state = ACTION_STATE.IDLE
	
	_play_animation()

func _update_look_direction_to_point(point: Vector2) -> void:
	if point.y < -0.5:
		_look_direction = LOOK_DIRECTION.DOWN
	elif point.y > 0.5:
		_look_direction = LOOK_DIRECTION.UP
	elif point.x < 0:
		_look_direction = LOOK_DIRECTION.LEFT
		_is_sprite_flipped_h = false
	else:
		_look_direction = LOOK_DIRECTION.RIGHT
		_is_sprite_flipped_h = true

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
				LOOK_DIRECTION.UP:
					animation_player.play("attack_up")
				LOOK_DIRECTION.DOWN:
					animation_player.play("attack_down")
				LOOK_DIRECTION.RIGHT:
					animation_player.play("attack")
				LOOK_DIRECTION.LEFT:
					animation_player.play("attack_flipped_h")
