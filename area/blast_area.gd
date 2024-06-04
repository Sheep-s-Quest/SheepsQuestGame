class_name BlastArea
extends DamageArea

@export var blast_scale: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()
	self.area_entered.connect(_on_area_entered)
	sprite.scale *= blast_scale
	collision_shape.size *= blast_scale
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play("idle")
	
func _on_area_entered(area) -> void:
	var body = area.get_parent()
	if "take_damage" in body:
		body.take_damage(damage, self.position.normalized())
		damage_hit.emit(body, self.position)

func _on_animation_finished(_ignored) -> void:
	queue_free()
