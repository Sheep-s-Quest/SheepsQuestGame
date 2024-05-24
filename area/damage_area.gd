extends Area2D
class_name DamageArea

signal damage_hit(target)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var damage: float = 0

func _ready() -> void:
	pass
	
func set_shape_size(size: Vector2) -> void:
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		shape.size = size
	

func _on_body_entered(body) -> void:
	if "take_damage" in body:
		body.take_damage(damage)
		damage_hit.emit(body)
