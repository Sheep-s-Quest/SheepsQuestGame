extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var player: CharacterBody2D = null
@export var move_speed: float = 200.0
@export var is_alive: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var hitbox: CollisionShape2D = $EnemyHitbox/CollisionShape2D
@onready var detection_area: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var nav: NavigationAgent2D = $NavigationAgent2D

var _current_state: ACTION_STATE = ACTION_STATE.IDLE
var _look_direction: LOOK_DIRECTION = LOOK_DIRECTION.LEFT
var _look_direction_x: bool = true
var _in_chase: bool = true
var _is_attack_possible: bool = false

func take_damage(damage: float) -> void:
	print(self.name, ": Damage hit: ", damage)

func _physics_process(_delta) -> void:
	if _in_chase and player and is_alive:
		var direction = to_local(nav.get_next_path_position()).normalized()
		velocity = direction * move_speed
		
		_current_state = ACTION_STATE.WALK
		_update_look_direction_to_point(direction)
		
		move_and_slide()
	else:
		_current_state = ACTION_STATE.IDLE
	
	_play_animation()

func _update_look_direction_to_point(point: Vector2) -> void:
	if point.y < -0.5:
		_look_direction = LOOK_DIRECTION.DOWN
	elif point.y > 0.5:
		_look_direction = LOOK_DIRECTION.UP
	elif point.x < 0:
		_look_direction = LOOK_DIRECTION.LEFT
		_look_direction_x = false
	else:
		_look_direction = LOOK_DIRECTION.RIGHT
		_look_direction_x = true

func _play_animation() -> void:
	match _current_state:
		ACTION_STATE.IDLE:
			if _look_direction_x:
				animation_player.play("idle")
			else:
				animation_player.play("idle_flipped_h")	
		ACTION_STATE.WALK:
			if _look_direction_x:
				animation_player.play("walk")
			else:
				animation_player.play("walk_flipped_h")
		ACTION_STATE.ATTACK:
			match _look_direction:
				LOOK_DIRECTION.UP:
					animation_player.play("attack_up")
				LOOK_DIRECTION.DOWN:
					animation_player.play("attack_down")
				LOOK_DIRECTION.RIGHT:
					animation_player.play("attack")
				LOOK_DIRECTION.LEFT:
					animation_player.play("attack_flipped_h")


func _makepath():
	nav.target_position = player.global_position


func _on_pathfinding_timer_timeout():
	_makepath()

#func _on_detection_area_area_entered(area):
	#if area.get_parent().name == "Player":
		#print("Entered")
		#_player = area.get_parent()
		#_in_chase = true
#
#func _on_detection_area_area_exited(area):
	#if area.get_parent().name == "Player":
		#print("Exited")
		#_player = null
		#_in_chase = false
