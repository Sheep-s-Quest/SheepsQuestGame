extends Node2D

@export var deco_layer_name = "Deco"
@export var player_z_index = 1
@export var player_next_z_index = 1
@export var physics_layer = 1
@export var physics_next_layer = 1

@onready var tilemap = $"../TileMap"
@onready var _deco_level_name_id = tilemap.get_layer_id_by_name(deco_layer_name)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_enter_body_exited(body: CharacterBody2D):
	_set_layer_collision(body, player_z_index, true, false)


func _on_area_2d_exit_body_exited(body: CharacterBody2D):
	_set_layer_collision(body, player_next_z_index, false, true)
	

func _set_layer_collision(body: CharacterBody2D, player_z_index, is_active, is_next_active):
	body.z_index = player_z_index
	body.set_collision_layer_value(physics_layer, is_active)
	body.set_collision_mask_value(physics_layer, is_active)
	body.set_collision_layer_value(physics_next_layer, is_next_active)
	body.set_collision_mask_value(physics_next_layer, is_next_active)
	tilemap.set_layer_z_index(_deco_level_name_id, player_z_index)
	
