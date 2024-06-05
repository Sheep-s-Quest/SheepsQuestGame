class_name Enemy
extends BasicEntity

@export var is_alive: bool = true

var player: CharacterBody2D = null
var in_chase: bool = false

@onready var detection_area_component: Area2D = $DetectionAreaComponent
@onready var navigation: NavigationComponent = $NavigationComponent


func _handle_default_state() -> void:
	if !is_instance_valid(player):
		player = null
	
	if in_chase and player and is_alive:
		navigation.set_target(player, self)
		var direction = to_local(navigation.get_navigation_path()).normalized()
		_update_look_direction_to_point(direction)
		
		if _is_possible_melee_attack(player):
			if attack_component.is_attack_possible:
				_current_state = ACTION_STATE.ATTACK
				attack()
			else:
				_current_state = ACTION_STATE.IDLE
		else:
			velocity_component.move(direction)
			_current_state = ACTION_STATE.WALK
			
		navigation.check_distance()
	else:
		_current_state = ACTION_STATE.IDLE

func _init_detection_area() -> void:
	detection_area_component.area_entered.connect(_on_detection_area_area_entered)
	#detection_area_component.area_exited.connect(_on_detection_area_area_exited)
	navigation.target_far.connect(_target_far)

func _update_look_direction_to_point(point: Vector2) -> void:
	if point.y < -0.5:
		_look_direction = LOOK_DIRECTION.UP
	elif point.y > 0.5:
		_look_direction = LOOK_DIRECTION.DOWN
	elif point.x < 0:
		_look_direction = LOOK_DIRECTION.LEFT
		_is_sprite_flipped_h = false
	else:
		_look_direction = LOOK_DIRECTION.RIGHT
		_is_sprite_flipped_h = true

func _is_possible_melee_attack(player: Node2D) -> bool:
	return !position.distance_to(player.position) >= attack_component.calculate_attack_range()

func _on_detection_area_area_entered(area) -> void:
	if area.get_parent().is_in_group("Player"):
		player = area.get_parent()
		in_chase = true

#func _on_detection_area_area_exited(area) -> void:
	#if area.get_parent().name == "Player":
		#player = null
		#in_chase = false

func _target_far() -> void:
	in_chase = false
	player = null
