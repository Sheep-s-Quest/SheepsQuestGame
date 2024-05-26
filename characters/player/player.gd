extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var action_state: ACTION_STATE = ACTION_STATE.IDLE
@export var attack_offset: float = 25.0
@export var current_direction: LOOK_DIRECTION = LOOK_DIRECTION.RIGHT
@export var sprite_offset_y: float = -30.0
@export var move_speed: float = 300.0

var _last_input_direction: Vector2 = Vector2(0.0, 0.0)

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var hitbox: CircleShape2D = $HitboxComponent/CollisionShape2D.get_shape()
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent

func _ready():
	health_component.damaged.connect(_on_damaged)
	attack_component.attack_overed.connect(_on_attack_overed)
	_last_input_direction = Vector2(1, 0)

func _physics_process(_delta: float) -> void:
	if action_state == ACTION_STATE.ATTACK:
		return
		
	var input_direction: Vector2 = _get_input_direction().normalized()
	velocity = input_direction * move_speed
	
	move_and_slide()
	_update_last_input_direction(input_direction)
	_update_look_direction(input_direction)
	_update_action_state(input_direction)
	_pick_animation_state()
	

func take_damage(damage: float, direction: Vector2) -> void:
	health_component.take_damage(damage, direction)
	apply_bounce(damage, direction)

func die() -> void:
	health_component.die()

func attack():
	var offset: Vector2 = Vector2.ZERO
	
	var hitbox_size: Vector2 = Vector2(hitbox.radius * 2, hitbox.radius * 2)
	var size = Vector2(75, 40)
	match current_direction:
		LOOK_DIRECTION.LEFT:
			offset = Vector2(-(hitbox_size.x / 2 + attack_offset), sprite_offset_y)
			size = Vector2(size.y, size.x)
		LOOK_DIRECTION.RIGHT:
			offset = Vector2(hitbox_size.x / 2 + attack_offset, sprite_offset_y)
			size = Vector2(size.y, size.x)
		LOOK_DIRECTION.UP:
			offset = Vector2(0, -(hitbox_size.y / 2 + attack_offset) + sprite_offset_y)
		LOOK_DIRECTION.DOWN:
			offset = Vector2(0, hitbox_size.y / 2 + attack_offset + sprite_offset_y)
	var attack_position = health_component.position + offset
	attack_component.attack(attack_position, size)
	

func apply_bounce(bounce_force: float, direction: Vector2) -> void:
	var impulse = direction * bounce_force
	move_and_collide(impulse)
	

func _update_last_input_direction(input_direction: Vector2) -> void:
	if input_direction == Vector2.ZERO:
		return
	if input_direction.x == 0.0:
		if abs(_last_input_direction.x) > 0.1:
			_last_input_direction.x *= 0.1
		_last_input_direction.y = input_direction.y
	elif input_direction.y == 0.0:
		_last_input_direction.x = input_direction.x
		if abs(_last_input_direction.y) > 0.1:
			_last_input_direction.y *= 0.1
	else:
		_last_input_direction = input_direction

func _get_input_direction() -> Vector2:
	var move_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(move_x, move_y)

func _update_action_state(input_direction: Vector2) -> void:
	if Input.is_action_just_pressed("attack") && attack_component.is_attack_possible:
		action_state = ACTION_STATE.ATTACK
		attack()
		return
	if input_direction != Vector2.ZERO:
		action_state = ACTION_STATE.WALK
	else:
		action_state = ACTION_STATE.IDLE

func _update_look_direction(move_input: Vector2) -> void:
	if move_input != Vector2.ZERO:
		if move_input.x > 0:
			current_direction = LOOK_DIRECTION.RIGHT
		elif move_input.x < 0:	
			current_direction = LOOK_DIRECTION.LEFT 
		
		if move_input.y > 0:
			current_direction = LOOK_DIRECTION.DOWN
		elif move_input.y < 0:
			current_direction = LOOK_DIRECTION.UP

func _pick_animation_state() -> void:
	if action_state == ACTION_STATE.ATTACK:
		animation_tree.set("parameters/Attack1/blend_position", _last_input_direction)
		animation_state.travel("Attack1")
		return
		
	if (velocity != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", _last_input_direction)
		animation_state.travel("Walk")
	else:
		animation_tree.set("parameters/Idle/blend_position", _last_input_direction)
		animation_state.travel("Idle")

func _on_attack_overed():
	action_state = ACTION_STATE.IDLE

func _on_damaged(damage: float, direction: Vector2) -> void:
	print("Player took damage: ", damage, " from direction: ", direction)
	if health_component.hit_points <= 0:
		die()
	
func _on_player_died() -> void:
	print("Player died")
	queue_free()
