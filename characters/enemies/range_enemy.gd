class_name RangeEnemy
extends Enemy

@onready var ranged_attack_component: RangedAttackComponent = $RangedAttackComponent


func _handle_default_state() -> void:
	if in_chase and player and is_alive:
		navigation.set_target(player, self)
		var direction = to_local(navigation.get_navigation_path()).normalized()
		_update_look_direction_to_point(direction)
		
		if _is_possible_ranged_attack(player):
			_current_state = ACTION_STATE.RANGE_ATTACK
			ranged_attack(player)
		elif _is_possible_melee_attack(player):
			_current_state = ACTION_STATE.ATTACK
			attack()
		
		navigation.check_distance()
	else:
		_current_state = ACTION_STATE.IDLE

func _handle_is_valid_player() -> void:
	if !is_instance_valid(player):
		player = null

func _handle_ranged_attack_state() -> void:
	await animation_player.animation_finished
	_current_state = ACTION_STATE.IDLE

func ranged_attack(player: Node2D) -> void:
	var direction = Vec2Utils.calculate_direction(self.position, player.position)
	ranged_attack_component.attack(direction)

func _is_possible_ranged_attack(player: Node2D) -> bool:
	var is_valid_distance :bool = ranged_attack_component.attack_range >= position.distance_to(player.position)
	return is_valid_distance and ranged_attack_component.is_attack_possible
