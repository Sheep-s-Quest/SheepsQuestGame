extends CharacterBody2D

enum LOOK_DIRECTION {LEFT, RIGHT, UP, DOWN}
enum ACTION_STATE {IDLE, WALK, ATTACK}

@export var speed: float = 200.0

@onready var sprite: Sprite2D = $EnemyAnimations.get_node("Sprite2D")
@onready var animation_tree: AnimationTree = $EnemyAnimations.get_node("AnimationTree")
@onready var animation_player: AnimationPlayer = $EnemyAnimations.get_node("AnimationPlayer")
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var hitbox: CollisionShape2D = $EnemyHitbox.get_node("CollisionShape2D")
@onready var eyes_sensor: CollisionShape2D = $EnemySensors.get_node("CollisionShape2D")
@onready var attack_cooldown: Timer = $AttackCooldown
