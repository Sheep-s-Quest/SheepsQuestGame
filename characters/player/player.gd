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

func _physics_process(delta: float) -> void:
	if action_state == ACTION_STATE.ATTACK:
		return;
	
	var move_x: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_y: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	var input_direction: Vector2 = Vector2(move_x, move_y).normalized()
	
	if input_direction != Vector2.ZERO:
		action_state = ACTION_STATE.WALK
	else:
		action_state = ACTION_STATE.IDLE
	
	if Input.is_action_just_pressed("attack"):
		_attack(input_direction)
	
	_update_look_direction(input_direction)
	_pick_animation_state()
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	
func _attack(input_direction: Vector2) -> void:
	action_state = ACTION_STATE.ATTACK
	animation_tree.set("parameters/Attack1/blend_position", input_direction)

func _pick_animation_state() -> void:
	if action_state == ACTION_STATE.ATTACK:
		animation_state.travel("Attack1")
		return
		
	if (velocity != Vector2.ZERO):
		animation_state.travel("Walk")
	else:
		animation_state.travel("Idle")

func _update_look_direction(move_input: Vector2) -> void:
	if (move_input != Vector2.ZERO):
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
			


func _on_animation_tree_animation_finished(anim_name: StringName):
	print("Animation finished: ", anim_name)
	match anim_name:
		"attack_1", "attack_up_1", "attack_down_1":
			action_state = ACTION_STATE.WALK
