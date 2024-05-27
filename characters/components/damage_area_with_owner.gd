class_name DamageAreaWithOwner
extends DamageArea

var area_owner = null

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if "take_damage" in body and body != area_owner:
		print_debug(body)
		body.take_damage(damage, attack_position)
		damage_hit.emit(body, attack_position)
