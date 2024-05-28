class_name DamageAreaWithOwner
extends DamageArea

var area_owner: Node2D = null

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if "take_damage" in body and body != area_owner:
		attack_position = calculate_attack_position(area_owner.position, body.position)
		body.take_damage(damage, attack_position)
		damage_hit.emit(body, attack_position)
