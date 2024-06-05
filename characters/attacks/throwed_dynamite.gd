class_name ThrowedDynamite
extends RangedAttack

@export var sprite_rotation: float = 0.01

var _blast_scene: Resource = preload("res://area/blast_area.tscn")
var _is_blast_created: bool = false

@onready var before_damage_collision_timer: Timer = $BeforeDamageCollisionTimer

func _ready() -> void:
	super._ready()
	before_damage_collision_timer.wait_time = time_before_collision
	before_damage_collision_timer.timeout.connect(_on_time_before_collision_ended)
	before_damage_collision_timer.start()
	
	animation_player.play("idle")

func _create_blast() -> void:
	live_timer.stop()
	
	self.linear_velocity = Vector2.ZERO
	var blast: BlastArea = _blast_scene.instantiate()
	blast.position = position
	blast.damage = self.damage
	get_parent().add_child(blast)
	queue_free()
	

func _process(_delta: float) -> void:
	sprite.rotate(sprite_rotation * speed)

func _on_time_before_collision_ended() -> void:
	damageable_component.area_entered.connect(_on_damageable_area_area_entered)
	before_damage_collision_timer.stop()

func _on_blast_ended(id: int) -> void:
	queue_free()

func _on_live_time_ended() -> void:
	_create_blast()

func _on_damageable_area_area_entered(area: Area2D) -> void:
	_create_blast()
	
