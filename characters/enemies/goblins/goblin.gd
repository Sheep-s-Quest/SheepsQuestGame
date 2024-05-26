class_name Goblin
extends Enemy

func take_damage(damage: float, direction: Vector2) -> void:
	print(self.name, ": Damage hit: ", damage, " Direction: ", direction)

func _physics_process(_delta) -> void:
	if _in_chase and _player and is_alive:
		var direction = (_player.position - position).normalized()
		velocity = direction * move_speed
		
		_current_state = ACTION_STATE.WALK
		_update_look_direction_to_point(direction)
		
		move_and_slide()
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
		_look_direction_x = false
	else:
		_look_direction = LOOK_DIRECTION.RIGHT
		_look_direction_x = true

func _play_animation() -> void:
	match _current_state:
		ACTION_STATE.IDLE:
			if _look_direction_x:
				animation_player.play("idle")
			else:
				animation_player.play("idle_flipped_h")	
		ACTION_STATE.WALK:
			if _look_direction_x:
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
