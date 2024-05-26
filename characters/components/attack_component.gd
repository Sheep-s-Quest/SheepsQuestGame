class_name AttackComponent
extends Node2D

signal attack_overed

@export var damage: float = 50
@export var livetime: float = 0.5
@export var attack_cooldown: float = 1.0

var is_attack_possible: bool = true
var _attack_area: DamageArea = null
var _damage_area_scene = preload("res://area/damage_area.tscn")

@onready var attack_livetime: Timer = $AttackTimer

func _ready():
	attack_livetime.timeout.connect(_on_attack_livetime_ended)
	attack_livetime.wait_time = livetime

func attack(position: Vector2, size: Vector2) -> void:
	if is_attack_possible:
		is_attack_possible = false
		attack_livetime.start()
		_attack_area = _damage_area_scene.instantiate()
		add_child(_attack_area)
		_attack_area.position = position
		_attack_area.size = size
		_attack_area.damage = damage
		
		_attack_area.set_shape_size(size)
	
func _on_attack_livetime_ended() -> void:
	if _attack_area != null:
		remove_child(_attack_area)
		_attack_area.queue_free()
		attack_overed.emit()
		is_attack_possible = true
