class_name BasicEntity
extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}
enum LAYER_POSITION {FIRST_LAYER = 1, SECOND_LAYER = 2, THIRD_LAYER = 3}

var _base_damage_layer = 8
var _last_input_direction: Vector2 = Vector2.ZERO
var _is_sprite_flipped_h: bool = false
var _current_state: ACTION_STATE = ACTION_STATE.IDLE
var _look_direction: LOOK_DIRECTION = LOOK_DIRECTION.RIGHT
var _layer_position: LAYER_POSITION = LAYER_POSITION.FIRST_LAYER

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CircleShape2D = $HitboxComponent/CollisionShape2D.get_shape()
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _init_health_system() -> void:
	health_component.damaged.connect(_on_damaged)
	health_component.died.connect(_on_died)

func _init_attack_system() -> void:
	attack_component.attack_overed.connect(_on_attack_overed)
	
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
	var damage_layer_position = _base_damage_layer + (_layer_position - 1)
	attack_component.attack(attack_position, damage_layer_position, flip_attack_hitbox)

func take_damage(damage: float, direction: Vector2) -> void:
	health_component.take_damage(damage, direction)
	velocity_component.apply_bounce(damage, direction)

func set_layer_position(layer: LAYER_POSITION):
	_layer_position = layer

func _on_attack_overed():
	_current_state = ACTION_STATE.IDLE

func _on_damaged(damage: float, direction: Vector2) -> void:
	print(self.name, " took damage: ", damage, " from direction: ", direction, " current HP: ", health_component.hit_points)
	if health_component.hit_points <= 0:
		health_component.die()

func _on_died() -> void:
	queue_free()
