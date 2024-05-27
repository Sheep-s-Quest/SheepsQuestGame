class_name Goblin
extends Enemy

func _ready():
	_init_detection_area()
	_init_health_system()
	_init_attack_system()
	
	
func _physics_process(_delta) -> void:
	if _current_state == ACTION_STATE.ATTACK:
		return
	
	if in_chase and player and is_alive:
		var direction = (player.position - position).normalized()
		_update_look_direction_to_point(direction)
		
		if position.distance_to(player.position) >= attack_component.calculate_attack_range():
			velocity_component.move(direction)
			_current_state = ACTION_STATE.WALK
		else:
			_current_state = ACTION_STATE.ATTACK
			attack()
	else:
		_current_state = ACTION_STATE.IDLE
	
	_play_animation()

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
