extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var move_speed: float = 300.0
@export var current_direction: LOOK_DIRECTION = LOOK_DIRECTION.RIGHT
@export var action_state: ACTION_STATE = ACTION_STATE.IDLE

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var attack_cooldown: Timer = $AttackCooldown

func _ready():
	animation_tree.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if action_state == ACTION_STATE.ATTACK:
		await animation_tree.animation_finished
		return
		
	var input_direction: Vector2 = _get_input_direction()
	
	_update_action_state(input_direction)
	_update_look_direction(input_direction)
	_pick_animation_state(input_direction)
	
	velocity = input_direction * move_speed
	move_and_slide()


func _update_action_state(input_direction: Vector2) -> void:
	if Input.is_action_just_pressed("attack"):
		action_state = ACTION_STATE.ATTACK
		return
	if input_direction != Vector2.ZERO:
		action_state = ACTION_STATE.WALK
	else:
		action_state = ACTION_STATE.IDLE

func _get_input_direction() -> Vector2:
	var move_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(move_x, move_y).normalized()

func _pick_animation_state(input_direction: Vector2) -> void:
	if action_state == ACTION_STATE.ATTACK:
		animation_tree.set("parameters/Attack1/blend_position", input_direction.round())
		animation_state.travel("Attack1")
		return
		
	if (velocity != Vector2.ZERO):
		animation_state.travel("Walk")
	else:
		animation_state.travel("Idle")

func _update_look_direction(move_input: Vector2) -> void:
	if move_input != Vector2.ZERO:
		if move_input.x > 0:
			current_direction = LOOK_DIRECTION.RIGHT
			sprite.flip_h = false
		elif move_input.x < 0:	
			current_direction = LOOK_DIRECTION.LEFT
			sprite.flip_h = true
		
		if move_input.y > 0:
			current_direction = LOOK_DIRECTION.DOWN
		elif move_input.y < 0:
			current_direction = LOOK_DIRECTION.UP

func _on_animation_finished(anim_name: StringName) -> void:
	print("Animation finished: ", anim_name)
	if anim_name.begins_with("attack"):
		action_state = ACTION_STATE.IDLE
