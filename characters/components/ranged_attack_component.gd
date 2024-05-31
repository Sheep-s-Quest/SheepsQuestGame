class_name RangedAttackComponent
extends Node2D


@export var attack_emmiter: Node2D = null
@export var ranged_attack_type: RANGED_ATTACK.TYPE = 0

@onready var _ranged_attack_scene: Resource = RANGED_ATTACK.get_scene(ranged_attack_type)


func attack(direction: Vector2) -> void:
	var attack: RangedAttack = _ranged_attack_scene.instantiate()
	attack.direction = direction
	add_child(attack)
