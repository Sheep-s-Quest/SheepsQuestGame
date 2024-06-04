class_name RangedAttack
extends RigidBody2D

@export var damage: float = 0.0
@export var live_time: float = 10.0
@export var speed: float = 1.5
@export var direction: Vector2 = Vector2.ZERO
@export var time_before_collision: float = 0.2

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var live_timer: Timer = $LiveTimer
@onready var damageable_component: Area2D = $DamageableComponent


func _ready() -> void:
	live_timer.wait_time = live_time
	live_timer.timeout.connect(_on_live_time_ended)
	live_timer.start()
	linear_velocity = direction * speed

func _on_live_time_ended() -> void:
	queue_free()

func _on_damageable_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is BasicEntity:
		parent.take_damage(damage, self.linear_velocity)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
