class_name Enemy
extends BasicEntity

@export var is_alive: bool = true

var player: CharacterBody2D = null
var in_chase: bool = false

@onready var detection_area_component: Area2D = $DetectionAreaComponent

func _ready() -> void:
	detection_area_component.area_entered.connect(_on_detection_area_area_entered)
	detection_area_component.area_exited.connect(_on_detection_area_area_exited)

func _on_detection_area_area_entered(area):
	if area.get_parent().name == "Player":
		player = area.get_parent()
		in_chase = true

func _on_detection_area_area_exited(area):
	if area.get_parent().name == "Player":
		player = null
		in_chase = false
