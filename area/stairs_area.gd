extends Node2D

@export var tilemap_level: int = 1
@export var tilemap_next_level: int = 1
@export var player_z_index: int = 1
@export var player_next_z_index: int = 1
@export var tilemap: TileMap;
@export var player: CharacterBody2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_enter_body_entered(body):
	tilemap.set_layer_enabled(tilemap_level, true)
	tilemap.set_layer_enabled(tilemap_next_level, false)
	player.z_index = player_z_index
	print("Tilemap level: ",tilemap_level," is ",tilemap.is_layer_enabled(tilemap_level))
	print("Tilemap level: ",tilemap_next_level," is ",tilemap.is_layer_enabled(tilemap_next_level))


func _on_area_2d_exit_body_entered(body):
	tilemap.set_layer_enabled(tilemap_level, false)
	tilemap.set_layer_enabled(tilemap_next_level, true)
	player.z_index = player_next_z_index
	print("Tilemap level: ",tilemap_level," is ",tilemap.is_layer_enabled(tilemap_level))
	print("Tilemap level: ",tilemap_next_level," is ",tilemap.is_layer_enabled(tilemap_next_level))
