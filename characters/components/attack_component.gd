class_name AttackComponent
extends Node2D

signal attack_overed

@export var attack_emmiter: Node2D = null
@export var attack_area_size: Vector2 = Vector2(100, 50)
@export var damage: float = 50
@export var livetime: float = 0.5
@export var attack_cooldown: float = 1.0

var is_attack_possible: bool = true
var _attack_area: DamageAreaWithOwner = null
var _damage_area_scene = preload("res://characters/components/damage_area_with_owner.tscn")

@onready var attack_livetime: Timer = $AttackTimer

func _ready():
	attack_livetime.timeout.connect(_on_attack_livetime_ended)
	attack_livetime.wait_time = livetime

func attack(attack_position: Vector2, flip_size: bool = false) -> void:
	if is_attack_possible:
		var size = attack_area_size
		if flip_size:
			size = Vector2(size.y, size.x)
		
		is_attack_possible = false
		attack_livetime.start()
		_attack_area = _damage_area_scene.instantiate()
		_attack_area.area_owner = attack_emmiter
		_attack_area.position = attack_position
		_attack_area.size = size
		_attack_area.damage = damage
		add_child(_attack_area)
		
		_attack_area.set_shape_size(size)

func attack_with_size(attack_position: Vector2, size: Vector2 = self.attack_area_size, flip_size: bool = false) -> void:
	if is_attack_possible:
		if flip_size:
			size = Vector2(size.y, size.x)
		
		is_attack_possible = false
		attack_livetime.start()
		_attack_area = _damage_area_scene.instantiate()
		add_child(_attack_area)
		_attack_area.area_owner = attack_emmiter
		_attack_area.position = attack_position
		_attack_area.size = size
		_attack_area.damage = damage
		
		_attack_area.set_shape_size(size)
	
func _on_attack_livetime_ended() -> void:
	if _attack_area != null:
		remove_child(_attack_area)
		_attack_area.queue_free()
		attack_overed.emit()
		is_attack_possible = true
