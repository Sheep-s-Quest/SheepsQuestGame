extends Area2D
class_name DamageArea

signal damage_hit(target, direction: Vector2)

var size: Vector2 = Vector2(100, 100)
@onready var collision_shape = $CollisionShape2D

var damage: float = 0
var attacker_position: Vector2 = Vector2.ZERO

func _ready():
	pass
	
func set_shape_size(size: Vector2) -> void:
	collision_shape.shape.size = size

func set_atacker_position(position: Vector2) -> void:
	attacker_position = position

func _on_body_entered(body) -> void:
	if "take_damage" in body:
		body.take_damage(damage, attacker_position)
		damage_hit.emit(body, attacker_position)
	
