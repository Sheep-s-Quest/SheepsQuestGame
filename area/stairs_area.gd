extends Node2D

@export var deco_layer_name = "Deco"
@export var level_name = "GroundCollision"
@export var next_level_name = "TopGroundLevel1Collision"
@export var player_z_index = 1
@export var player_next_z_index = 1


@onready var player = $"../Player"
@onready var tilemap = $"../TileMap"
@onready var _level_name_id = tilemap.get_layer_id_by_name(level_name)
@onready var _next_level_name_id = tilemap.get_layer_id_by_name(next_level_name)
@onready var _deco_level_name_id = tilemap.get_layer_id_by_name(deco_layer_name)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_enter_body_exited(_body):
	_set_layer_collision(true, false, player_z_index)


func _on_area_2d_exit_body_exited(_body):
	_set_layer_collision(false, true, player_next_z_index)
	

func _set_layer_collision(is_level_active, is_next_level_active, player_z_index):
	tilemap.set_layer_enabled(_level_name_id, is_level_active)
	tilemap.set_layer_enabled(_next_level_name_id, is_next_level_active)
	player.z_index = player_z_index
	tilemap.set_layer_z_index(_deco_level_name_id, player_z_index)
	
