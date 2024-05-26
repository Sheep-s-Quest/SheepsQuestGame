class_name Enemy
extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var move_speed: float = 200.0
@export var is_alive: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var attack_cooldown: Timer = $AttackCooldown

var _current_state: ACTION_STATE = ACTION_STATE.IDLE
var _look_direction: LOOK_DIRECTION = LOOK_DIRECTION.LEFT
var _look_direction_x: bool = true
var _player: CharacterBody2D = null
var _in_chase: bool = false
var _is_attack_possible: bool = false

func _ready():
	pass

func _on_detection_area_area_entered(area):
	if area.get_parent().name == "Player":
		print_debug("Entered")
		_player = area.get_parent()
		_in_chase = true

func _on_detection_area_area_exited(area):
	if area.get_parent().name == "Player":
		print_debug("Exited")
		_player = null
		_in_chase = false
