class_name AttackComponent
extends Node2D

signal attack_overed

@export var attack_emmiter: Node2D = null
@export var attack_area_size: Vector2 = Vector2(100, 50)
@export var damage: float = 50
@export var attack_livetime: float = 0.5
@export var attack_cooldown: float = 1.0
@export var time_before_attack_creatioon: float = 0.1
@export var attack_sound_source: AudioStream

var is_attack_possible: bool = true
var _attack_area: DamageAreaWithOwner = null
var _damage_area_scene = preload("res://characters/components/damage_area_with_owner.tscn")


@onready var attack_creation_timer: Timer = $AttackCreationTimer
@onready var attack_livetime_timer: Timer = $AttackLivetimeTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_sound: AudioStreamPlayer2D = $AttackSound

func _ready():
	attack_creation_timer.timeout.connect(_on_attack_creation_ended)
	attack_creation_timer.wait_time = time_before_attack_creatioon
	
	attack_livetime_timer.timeout.connect(_on_attack_livetime_ended)
	attack_livetime_timer.wait_time = attack_livetime
	
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_ended)
	attack_cooldown_timer.wait_time = attack_cooldown
	
	attack_sound.stream = attack_sound_source

func attack(attack_position: Vector2, collision_layer: int, flip_size: bool = false) -> void:
	attack_with_size(attack_position, collision_layer, attack_area_size, flip_size)
	attack_sound.play()

func attack_with_size(attack_position: Vector2, collision_layer: int, size: Vector2 = self.attack_area_size, flip_size: bool = false) -> void:
	if is_attack_possible:
		if flip_size:
			size = Vector2(size.y, size.x)
		
		is_attack_possible = false
		_attack_area = _damage_area_scene.instantiate()
		_set_damage_area_layer(collision_layer)
		_attack_area.area_owner = attack_emmiter
		_attack_area.position = attack_position
		_attack_area.size = size
		_attack_area.damage = damage
		
		attack_creation_timer.start()
		attack_livetime_timer.start()
		attack_cooldown_timer.start()

func calculate_attack_range() -> float:
	return max(attack_area_size.x, attack_area_size.y) / 1.5

func _set_damage_area_layer(collision_layer: int) -> void:
	_attack_area.set_collision_layer_value(collision_layer - 1, false)
	_attack_area.set_collision_mask_value(collision_layer - 1, false)
	_attack_area.set_collision_layer_value(collision_layer, true)
	_attack_area.set_collision_mask_value(collision_layer, true)

func _on_attack_creation_ended() -> void:
	if _attack_area != null:
		add_child(_attack_area)

func _on_attack_cooldown_ended() -> void:
	is_attack_possible = true

func _on_attack_livetime_ended() -> void:
	if _attack_area != null:
		remove_child(_attack_area)
		_attack_area.queue_free()
		attack_overed.emit()
