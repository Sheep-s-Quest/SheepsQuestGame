class_name RangedAttack
extends RigidBody2D

@export var damage: float = 0.0
@export var live_time: float = 10.0
@export var speed: float = 1.5
@export var direction: Vector2 = Vector2.ZERO
@export var time_before_collision: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var live_timer: Timer = $LiveTimer
@onready var before_damage_collision_timer: Timer = $BeforeDamageCollisionTimer
@onready var damageable_component: Area2D = $DamageableComponent


func _ready() -> void:
	before_damage_collision_timer.wait_time = time_before_collision
	before_damage_collision_timer.timeout.connect(_on_time_before_collision_ended)
	before_damage_collision_timer.start()
	
	live_timer.wait_time = live_time
	live_timer.timeout.connect(_on_live_time_ended)
	live_timer.start()
	linear_velocity = direction * speed
	

func _physics_process(delta):
	print(self, " current position: ", position)

func _on_live_time_ended() -> void:
	queue_free()

func _on_time_before_collision_ended() -> void:
	damageable_component.area_entered.connect(_on_damageable_area_area_entered)

func _on_damageable_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is BasicEntity:
		parent.take_damage(damage, self.linear_velocity)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
