class_name RangedAttackComponent
extends Node2D

@export var attack_emmiter: Node2D = null
@export var ranged_attack_type: RANGED_ATTACK.TYPE = 0
@export var attack_cooldown: float = 3.0
@export var attack_range: float = 200.0

var is_attack_possible: bool = true

@onready var attack_cooldown_timer: Timer = $CooldownTimer
@onready var _ranged_attack_scene: Resource = RANGED_ATTACK.get_scene(ranged_attack_type)

func _ready() -> void:
	attack_cooldown_timer.wait_time = attack_cooldown
	attack_cooldown_timer.timeout.connect(_on_cooldown_ended)

func attack(direction: Vector2) -> void:
	is_attack_possible = false
	var attack: RangedAttack = _ranged_attack_scene.instantiate()
	attack.direction = direction
	attack_cooldown_timer.start()
	add_child(attack)

func _on_cooldown_ended() -> void:
	is_attack_possible = true
