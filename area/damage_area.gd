extends Area2D
class_name DamageArea

signal damage_hit(target, direction: Vector2)

@export var damage: float = 0
@export var attack_position: Vector2 = Vector2.ZERO

var size: Vector2 = Vector2(100, 100)

@onready var collision_shape = $CollisionShape2D
	
func set_shape_size(size: Vector2) -> void:
	collision_shape.shape.size = size

func set_atacker_position(position: Vector2) -> void:
	attack_position = position

func _on_body_entered(body) -> void:
	if "take_damage" in body:
		body.take_damage(damage, attack_position)
		damage_hit.emit(body, attack_position)
	
