class_name HealthComponent
extends Node

signal damaged(damage: float, direction: Vector2)
signal died()

@export var max_hit_points: float = 100.0
@export var hit_points: float = 100.0
@export var damage_received_sound_source: AudioStream

@onready var damage_received_sound: AudioStreamPlayer2D = $DamageReceivedSound

func take_damage(damage: float, direction: Vector2) -> void:
	hit_points -= damage
	damaged.emit(damage, direction)
	damage_received_sound.play()

func restore_hitpoints(amount: float) -> void:
	if hit_points < max_hit_points:
		if hit_points + amount > max_hit_points:
			hit_points = max_hit_points
		else:
			hit_points += amount

func die() -> void:
	died.emit()

func _ready():
	damage_received_sound.stream = damage_received_sound_source
