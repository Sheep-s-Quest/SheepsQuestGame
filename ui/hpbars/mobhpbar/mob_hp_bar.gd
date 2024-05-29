extends Node2D

@onready var health_bar : TextureProgressBar = $HPBar
@onready var health_component: HealthComponent = $"../HealthComponent"

func _ready():
	_init_hp_bar()

func _physics_process(delta):
	_update_health_bar()

func _init_hp_bar() -> void:
	health_bar.max_value = health_component.max_hit_points
	health_bar.value = health_component.max_hit_points
	health_bar.visible = false


func _update_health_bar() -> void:
	health_bar.value = health_component.hit_points
	if health_bar.value != health_component.max_hit_points:
		health_bar.visible = true
