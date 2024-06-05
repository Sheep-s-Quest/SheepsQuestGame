class_name DamageArea
extends Area2D

signal damage_hit(target, direction: Vector2)

@export var damage: float = 0
@export var attack_position: Vector2 = Vector2.ZERO
@export var size: Vector2 = Vector2(100, 100)

@onready var collision_shape: RectangleShape2D = $CollisionShape2D.shape

func _ready():
	collision_shape.size = size

func set_shape_size(size: Vector2) -> void:
	collision_shape.size = size

func set_atacker_position(position: Vector2) -> void:
	attack_position = position

func _on_area_entered(area) -> void:
	var body = area.get_parent()
	if "take_damage" in body:
		body.take_damage(damage, attack_position)
		damage_hit.emit(body, attack_position)

