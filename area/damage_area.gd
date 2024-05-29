class_name DamageArea
extends Area2D

signal damage_hit(target, direction: Vector2)

@export var damage: float = 0
@export var attack_position: Vector2 = Vector2.ZERO

var size: Vector2 = Vector2(100, 100)

var collision_shape: RectangleShape2D = null

func _ready():
	collision_shape = RectangleShape2D.new()
	collision_shape.size = size

func set_shape_size(size: Vector2) -> void:
	collision_shape.size = size

func set_atacker_position(position: Vector2) -> void:
	attack_position = position

func calculate_attack_direction(emmiter_position: Vector2, target_position: Vector2) -> Vector2:
	return -1 * (emmiter_position - target_position)

func _on_body_entered(body) -> void:
	if "take_damage" in body:
		body.take_damage(damage, attack_position)
		damage_hit.emit(body, attack_position)

