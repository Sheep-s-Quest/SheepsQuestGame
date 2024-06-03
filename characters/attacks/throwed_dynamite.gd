class_name ThrowedDynamite
extends RangedAttack

@export var sprite_rotation: float = 0.01

var _damage_area_scene: Resource = preload("res://area/damage_area.tscn")

@onready var before_damage_collision_timer: Timer = $BeforeDamageCollisionTimer

func _ready() -> void:
	super._ready()
	before_damage_collision_timer.wait_time = time_before_collision
	before_damage_collision_timer.timeout.connect(_on_time_before_collision_ended)
	before_damage_collision_timer.start()
	
	animation_player.play("idle")

func _process(_delta: float) -> void:
	sprite.rotate(sprite_rotation * speed)

func _on_time_before_collision_ended() -> void:
	damageable_component.area_entered.connect(_on_damageable_area_area_entered)
	before_damage_collision_timer.stop()
