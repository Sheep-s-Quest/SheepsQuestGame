class_name BasicEntity
extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

var _last_input_direction: Vector2 = Vector2.ZERO
var _is_sprite_flipped_h: bool = false
var _current_state: ACTION_STATE = ACTION_STATE.IDLE
var _look_direction: LOOK_DIRECTION = LOOK_DIRECTION.RIGHT

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CircleShape2D = $HitboxComponent/CollisionShape2D.get_shape()
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent

func _ready():
	health_component.damaged.connect(_on_damaged)
	attack_component.attack_overed.connect(_on_attack_overed)
	_last_input_direction = Vector2.RIGHT

func attack():
	var offset: Vector2 = Vector2.ZERO	
	var hitbox_size: Vector2 = Vector2(hitbox.radius * 2, hitbox.radius * 2)
	var flip_attack_hitbox: bool = false
	match _look_direction:
		LOOK_DIRECTION.LEFT:
			offset = Vector2(-(hitbox_size.x / 2), 0)
			flip_attack_hitbox = true
		LOOK_DIRECTION.RIGHT:
			offset = Vector2(hitbox_size.x / 2, 0)
			flip_attack_hitbox = true
		LOOK_DIRECTION.UP:
			offset = Vector2(0, -(hitbox_size.y / 2) + 0)
		LOOK_DIRECTION.DOWN:
			offset = Vector2(0, hitbox_size.y / 2 + 0)
	var attack_position = health_component.position + offset
	attack_component.attack(attack_position, flip_attack_hitbox)

func take_damage(damage: float, direction: Vector2) -> void:
	health_component.take_damage(damage, direction)
	velocity_component.apply_bounce(damage, direction)

func die() -> void:
	health_component.die()

func _on_attack_overed():
	_current_state = ACTION_STATE.IDLE

func _on_damaged(damage: float, direction: Vector2) -> void:
	print(self.name, " took damage: ", damage, " from direction: ", direction, " current HP: ", health_component.hit_points)
	
