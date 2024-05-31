class_name RangeEnemy
extends Enemy

@onready var ranged_attack_component: RangedAttackComponent = $RangedAttackComponent

func _handle_default_state() -> void:
	if in_chase and player and is_alive:
		navigation.set_target(player, self)
		var direction = to_local(navigation.get_navigation_path()).normalized()
		_update_look_direction_to_point(direction)
		
		if _is_possible_ranged_attack(player):
			ranged_attack()
		elif _is_possible_melee_attack(player):
			velocity_component.move(direction)
			_current_state = ACTION_STATE.WALK
		else:
			if attack_component.is_attack_possible:
				_current_state = ACTION_STATE.ATTACK
				attack()
			else:
				_current_state = ACTION_STATE.IDLE
		navigation.check_distance()
	else:
		_current_state = ACTION_STATE.IDLE

func ranged_attack() -> void:
	pass

func _is_possible_ranged_attack(player: Node2D) -> bool:
	return position.distance_squared_to(player.position) <= ranged_attack_component.attack_range and ranged_attack_component.is_attack_possible
