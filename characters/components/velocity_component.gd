class_name VelocityComponent
extends Node2D

@export var move_speed: float = 300.0
@export var moveable: CharacterBody2D = null
@export var impulse: Vector2 = Vector2.ZERO
@export var impulse_k: float = 0.01

func move(direction: Vector2) -> void:
	moveable.velocity = direction * move_speed
	moveable.move_and_slide()
	if impulse != Vector2.ZERO:
		moveable.move_and_collide(impulse)
		impulse *= impulse_k

func apply_bounce(bounce_force: float, direction: Vector2) -> void:
	impulse = direction * bounce_force * impulse_k
	moveable.move_and_collide(impulse)

func get_input_direction() -> Vector2:
	var move_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(move_x, move_y).normalized()