extends Node2D

@export var deco_layer_name = "Deco"
@export var pathfinding_layer_name = "Pathfinding_1"
@export var pathfinding_next_layer_name = "Pathfinding_2"
@export var player_z_index = 1
@export var player_next_z_index = 1
@export var physics_layer = 1
@export var physics_next_layer = 1

@onready var tilemap = $"../TileMap"
@onready var _deco_level_name_id = tilemap.get_layer_id_by_name(deco_layer_name)
@onready var nodes_enemy = get_tree().get_nodes_in_group("Enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_enter_body_exited(body: CharacterBody2D):
	_set_layer_collision(body, player_z_index, true, false, pathfinding_layer_name)


func _on_area_2d_exit_body_exited(body: CharacterBody2D):
	_set_layer_collision(body, player_next_z_index, false, true, pathfinding_next_layer_name)
	

func _set_layer_collision(body:, player_z_index, is_active, is_next_active, pathfinding_layer_name):
	body.z_index = player_z_index
	body.set_collision_layer_value(physics_layer, is_active)
	body.set_collision_mask_value(physics_layer, is_active)
	body.set_collision_layer_value(physics_next_layer, is_next_active)
	body.set_collision_mask_value(physics_next_layer, is_next_active)
	tilemap.set_layer_z_index(_deco_level_name_id, player_z_index)
	# if path is null, search path to stairs area for go to the next level
	if body.is_in_group("Enemy"):
		var nav: NavigationAgent2D = body.get_node("NavigationAgent2D")
		var nav_layer_id = tilemap.get_layer_id_by_name(pathfinding_layer_name)
		nav.set_navigation_map(tilemap.get_navigation_map(nav_layer_id))
	
