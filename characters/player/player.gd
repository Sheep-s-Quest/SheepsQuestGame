extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var hit_points: float = 300.0
@export var move_speed: float = 300.0
@export var current_direction: LOOK_DIRECTION = LOOK_DIRECTION.RIGHT
@export var action_state: ACTION_STATE = ACTION_STATE.IDLE
@export var attack_cooldown: float = 0.6

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var attack_cooldown_timer: Timer = $AttackCooldown

var _is_attack_possible: bool = true
var _last_input_direction: Vector2 = Vector2(0.0, 0.0)

func take_damage(damage: float) -> void:
	print("Damage hit: ", damage)

func _ready():
	attack_cooldown_timer.wait_time = attack_cooldown
	animation_tree.animation_finished.connect(_on_animation_finished)
	_last_input_direction = Vector2(1, 0)

func _physics_process(_delta: float) -> void:
	if action_state == ACTION_STATE.ATTACK:
		await animation_tree.animation_finished
		return
		
	var input_direction: Vector2 = _get_input_direction().normalized()
	_update_last_input_direction(input_direction)
	_update_look_direction(input_direction)
	_update_action_state(input_direction)
	_pick_animation_state()
	
	velocity = input_direction * move_speed
	move_and_slide()

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
	if Input.is_action_just_pressed("attack") and _is_attack_possible:
		action_state = ACTION_STATE.ATTACK
		attack_cooldown_timer.start()
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


func _on_animation_finished(anim_name: StringName) -> void:
	print("Animation finished: ", anim_name)

func _on_attack_cooldown_timeout():
	_is_attack_possible = true
	action_state = ACTION_STATE.IDLE
