class_name DamageAreaWithOwner
extends DamageArea

var area_owner: Node2D = null

func _ready():
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(area) -> void:
	var body = area.get_parent()
	if "take_damage" in body and body != area_owner:
		attack_position = calculate_attack_direction(area_owner.position, body.position).normalized()
		body.take_damage(damage, attack_position)
		damage_hit.emit(body, attack_position)
