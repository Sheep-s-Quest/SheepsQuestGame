class_name ThrowedDynamite
extends RangedAttack

@export var sprite_rotation: float = 0.01

func _ready() -> void:
	super._ready()
	animation_player.play("idle")
	
func _process(_delta: float) -> void:
	sprite.rotate(sprite_rotation * speed)
