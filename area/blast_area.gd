class_name BlastArea
extends DamageArea

@export var blast_scale: float = 1.0

var already_damaged: Array[Node] = []

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super._ready()
	self.area_entered.connect(_on_area_entered)
	sprite.scale *= blast_scale
	collision_shape.size *= blast_scale
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play("idle")
	
func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	var is_not_damaged: bool = body not in already_damaged
	var is_damageable: bool = "take_damage" in body
	if is_damageable and is_not_damaged:
		body.take_damage(damage, self.position.normalized())
		damage_hit.emit(body, self.position)
	already_damaged.append(body)
	
func _on_animation_finished(_ignored) -> void:
	queue_free()
