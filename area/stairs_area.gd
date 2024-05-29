class_name StairsArea
extends Node2D

signal used_stairs(stairs_area: StairsArea)

enum LAYER_POSITION {FIRST_LAYER, SECOND_LAYER, THIRD_LAYER}
@export var deco_layer_name = "Deco"
@export var pathfinding_layer_name = "Pathfinding_1"
@export var pathfinding_next_layer_name = "Pathfinding_2"
@export var from_layer: LAYER_POSITION = LAYER_POSITION.FIRST_LAYER
@export var to_layer: LAYER_POSITION = LAYER_POSITION.SECOND_LAYER
@export var player_z_index = 1
@export var player_next_z_index = 2
@export var physics_layer = 1
@export var physics_next_layer = 2
@export var detection_area_layer = 25
@export var detection_area_next_layer = 26

@onready var tilemap = $"../TileMap"
@onready var _deco_level_name_id = tilemap.get_layer_id_by_name(deco_layer_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_enter_body_exited(body: CharacterBody2D):
	_set_layer_collision(body, player_z_index, true, false, 
			pathfinding_layer_name, from_layer)


func _on_area_2d_exit_body_exited(body: CharacterBody2D):
	if body.is_in_group("Player"):
		used_stairs.emit(self)
	_set_layer_collision(body, player_next_z_index, false, true, 
			pathfinding_next_layer_name, to_layer)
	

func _set_layer_collision(body, new_z_index, is_active, is_next_active, 
		new_pathfinding_layer_name, layer_position):
	body.z_index = new_z_index
	body.set_collision_layer_value(physics_layer, is_active)
	body.set_collision_mask_value(physics_layer, is_active)
	body.set_collision_layer_value(physics_next_layer, is_next_active)
	body.set_collision_mask_value(physics_next_layer, is_next_active)
	
	#var detection_area = body.get_node("DelectionComponent")
	#detection_area.set_collision_layer_value(detection_area_layer, is_active)
	#detection_area.set_collision_layer_value(detection_area_next_layer, is_next_active)
	
	tilemap.set_layer_z_index(_deco_level_name_id, player_z_index)
	body.set_layer_position(layer_position)
	# if path is null, search path to stairs area for go to the next level
	if body.is_in_group("Enemy"):
		print("new_path ", new_pathfinding_layer_name)
		var nav: NavigationAgent2D = body.get_node("NavigationComponent")
		var nav_layer_id = tilemap.get_layer_id_by_name(new_pathfinding_layer_name)
		nav.set_navigation_map(tilemap.get_navigation_map(nav_layer_id))
	
