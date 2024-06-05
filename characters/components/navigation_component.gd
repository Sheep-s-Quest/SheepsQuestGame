class_name NavigationComponent
extends NavigationAgent2D

signal target_far()

@export var max_distance_to_target = 400

var main_target: Node2D

@onready var timer: Timer = $NavigationTimer
@onready var _stairs_area_list: Array[Node] = get_tree().get_nodes_in_group("Stairs")


func set_target(target: Node2D, enemy: Node2D):
	var is_target_can_reached = target._layer_position == enemy._layer_position
	if(target != null and is_target_can_reached):
		main_target = target
		_set_navigation_target(main_target)


func get_navigation_path() -> Vector2:
	var path: Vector2 = get_next_path_position()
	return path


func check_distance():
	if(distance_to_target() > max_distance_to_target):
		target_far.emit()


func _ready():
	for stairs_area in _stairs_area_list:
			stairs_area.used_stairs.connect(_used_stairs)


func _set_navigation_target(target: Node2D):
	var position = target.global_position
	if target.name.contains("StairsArea"):
		position = Vector2(position.x, position.y - 50)
	target_position = position


func _used_stairs(stairs_area: Node2D):
	_set_navigation_target(stairs_area)
