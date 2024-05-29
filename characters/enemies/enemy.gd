class_name Enemy
extends BasicEntity


@export var is_alive: bool = true


var player: CharacterBody2D = null
var in_chase: bool = false


@onready var detection_area_component: Area2D = $DetectionAreaComponent
@onready var health_bar : TextureProgressBar = $MobHpBar/HPBar



func _init_detection_area() -> void:
	detection_area_component.area_entered.connect(_on_detection_area_area_entered)
	detection_area_component.area_exited.connect(_on_detection_area_area_exited)


func _init_hp_bar() -> void:
	health_bar.max_value = health_component.max_hit_points
	health_bar.value = health_component.max_hit_points
	health_bar.visible = false


func _update_look_direction_to_point(point: Vector2) -> void:
	if point.y < -0.5:
		_look_direction = LOOK_DIRECTION.UP
	elif point.y > 0.5:
		_look_direction = LOOK_DIRECTION.DOWN
	elif point.x < 0:
		_look_direction = LOOK_DIRECTION.LEFT
		_is_sprite_flipped_h = false
	else:
		_look_direction = LOOK_DIRECTION.RIGHT
		_is_sprite_flipped_h = true


func _on_detection_area_area_entered(area) -> void:
	if area.get_parent().name == "Player":
		player = area.get_parent()
		in_chase = true


func _on_detection_area_area_exited(area) -> void:
	if area.get_parent().name == "Player":
		player = null
		in_chase = false


func _update_health_bar() -> void:
	health_bar.value = health_component.hit_points
	if health_bar.value != health_component.max_hit_points:
		health_bar.visible = true
