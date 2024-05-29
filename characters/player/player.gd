class_name Player
extends BasicEntity

@onready var health_bar : TextureProgressBar = $PlayerHP/HpBar

func _ready():
	_init_health_system()
	_init_attack_system()
	_init_hp_bar()

func _physics_process(_delta: float) -> void:
	_update_health_bar()
	if _current_state == ACTION_STATE.ATTACK:
		return
		
	var input_direction: Vector2 = velocity_component.get_input_direction()
	velocity_component.move(input_direction)
	
	_update_look_direction(input_direction)
	_update_current_state(input_direction)
	_play_animation()

func _update_current_state(input_direction: Vector2) -> void:
	if Input.is_action_just_pressed("attack") && attack_component.is_attack_possible:
		_current_state = ACTION_STATE.ATTACK
		attack()
		return
	if input_direction != Vector2.ZERO:
		_current_state = ACTION_STATE.WALK
	else:
		_current_state = ACTION_STATE.IDLE

func _update_look_direction(move_input: Vector2) -> void:
	if move_input != Vector2.ZERO:
		if move_input.x > 0:
			_look_direction = LOOK_DIRECTION.RIGHT
			_is_sprite_flipped_h = false
		elif move_input.x < 0:	
			_look_direction = LOOK_DIRECTION.LEFT
			_is_sprite_flipped_h = true 
		elif move_input.y > 0:
			_look_direction = LOOK_DIRECTION.DOWN
		elif move_input.y < 0:
			_look_direction = LOOK_DIRECTION.UP

func _play_animation() -> void:
	match _current_state:
		ACTION_STATE.IDLE:
			if _is_sprite_flipped_h:
				animation_player.play("idle_flipped_h")
			else:
				animation_player.play("idle")
		ACTION_STATE.WALK:
			if _is_sprite_flipped_h:
				animation_player.play("move_flipped_h")
			else:
				animation_player.play("move")
		ACTION_STATE.ATTACK:
			match _look_direction:
				LOOK_DIRECTION.UP:
					animation_player.play("attack_up_1")
				LOOK_DIRECTION.DOWN:
					animation_player.play("attack_down_1")
				LOOK_DIRECTION.RIGHT:
					animation_player.play("attack_1")
				LOOK_DIRECTION.LEFT:
					animation_player.play("attack_1_flipped_h")


func _init_hp_bar() -> void:
	health_bar.max_value = health_component.max_hit_points
	health_bar.value = health_component.max_hit_points

func _update_health_bar() -> void:
	health_bar.value = health_component.hit_points
