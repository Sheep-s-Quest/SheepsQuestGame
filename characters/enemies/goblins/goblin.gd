extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var move_speed: float = 200.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var hitbox: CollisionShape2D = $EnemyHitbox/CollisionShape2D
@onready var detection_area: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var attack_cooldown: Timer = $AttackCooldown

var _current_state: ACTION_STATE = ACTION_STATE.IDLE
var _last_look_direction: LOOK_DIRECTION = LOOK_DIRECTION.LEFT
var _player = null
var _in_chase: bool = false
var _is_attack_possible: bool = false

func _physics_process(_delta) -> void:
	if _in_chase and _player:
		var direction = (_player.position - position).normalized()
		velocity = direction * move_speed
		move_and_slide()
	
		if direction.x < 0:
			_last_look_direction = LOOK_DIRECTION.LEFT
		else:
			_last_look_direction = LOOK_DIRECTION.RIGHT
		

func _on_detection_area_body_entered(body):
	_player = body
	_in_chase = true

func _on_detection_area_body_exited(body):
	_player = null
	_in_chase = false
