class_name VelocityComponent
extends Node2D

@export var move_speed: float = 300.0
@export var moveable: CharacterBody2D = null
@export var impulse: Vector2 = Vector2.ZERO
@export var impulse_k: float = 0.01
@export var walking_sound_source: AudioStream

@onready var walking_sound: AudioStreamPlayer2D = $WalkingSound

func move(direction: Vector2) -> void:
	moveable.velocity = direction * move_speed
	moveable.move_and_slide()
	if impulse != Vector2.ZERO:
		moveable.move_and_collide(impulse)
		impulse *= impulse_k
	
	if moveable.velocity != Vector2.ZERO and not walking_sound.playing:
		walking_sound.play()

func apply_bounce(bounce_force: float, direction: Vector2) -> void:
	impulse = direction * bounce_force
	moveable.move_and_collide(impulse)

func get_input_direction() -> Vector2:
	var move_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var move_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(move_x, move_y).normalized()

func _ready():
	walking_sound.stream = walking_sound_source
