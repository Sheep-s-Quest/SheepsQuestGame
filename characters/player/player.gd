extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var sprite_offset_y: float = -30.0
@export var move_speed: float = 300.0

var _last_input_direction: Vector2 = Vector2(0.0, 0.0)
var _is_sprite_flipped_h: bool = false
var _current_state: ACTION_STATE = ACTION_STATE.IDLE
var _look_direction: LOOK_DIRECTION = LOOK_DIRECTION.RIGHT

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CircleShape2D = $HitboxComponent/CollisionShape2D.get_shape()
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent

func _ready():
	health_component.damaged.connect(_on_damaged)
	attack_component.attack_overed.connect(_on_attack_overed)
	_last_input_direction = Vector2(1, 0)

func _physics_process(_delta: float) -> void:
	if _current_state == ACTION_STATE.ATTACK:
		return
		
	var input_direction: Vector2 = _get_input_direction().normalized()
	velocity_component.move(input_direction)
	
	_update_look_direction(input_direction)
	_update_current_state(input_direction)
	_update_animation()

func take_damage(damage: float, direction: Vector2) -> void:
	health_component.take_damage(damage, direction)
	velocity_component.apply_bounce(damage, direction)

func die() -> void:
	health_component.die()

func attack():
	var offset: Vector2 = Vector2.ZERO	
	var hitbox_size: Vector2 = Vector2(hitbox.radius * 2, hitbox.radius * 2)
	var flip_attack_hitbox: bool = false
	match _look_direction:
		LOOK_DIRECTION.LEFT:
			offset = Vector2(-(hitbox_size.x / 2), sprite_offset_y)
			flip_attack_hitbox = true
		LOOK_DIRECTION.RIGHT:
			offset = Vector2(hitbox_size.x / 2, sprite_offset_y)
			flip_attack_hitbox = true
		LOOK_DIRECTION.UP:
			offset = Vector2(0, -(hitbox_size.y / 2) + sprite_offset_y)
		LOOK_DIRECTION.DOWN:
			offset = Vector2(0, hitbox_size.y / 2 + sprite_offset_y)
	var attack_position = health_component.position + offset
	attack_component.attack(attack_position, attack_component.attack_area_size, flip_attack_hitbox)

func _get_input_direction() -> Vector2:
	var move_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(move_x, move_y)

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

func _update_animation() -> void:
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


func _on_attack_overed():
	_current_state = ACTION_STATE.IDLE

func _on_damaged(damage: float, direction: Vector2) -> void:
	print("Player took damage: ", damage, " from direction: ", direction, " current HP: ", health_component.hit_points)
	
func _on_player_died() -> void:
	print("Player died")
	queue_free()
