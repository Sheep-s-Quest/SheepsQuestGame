class_name StairsArea
extends Node2D

signal used_stairs(stairs_area: StairsArea)

enum LAYER_POSITION {FIRST_LAYER = 1, SECOND_LAYER = 2, THIRD_LAYER = 3}
@export var deco_layer_name = "Deco"
@export var navigation_layer_name = "Navigation"
@export var from_layer: LAYER_POSITION = LAYER_POSITION.FIRST_LAYER
@export var to_layer: LAYER_POSITION = LAYER_POSITION.SECOND_LAYER
@export var detection_area_layer: = 25
@export var detection_area_next_layer = 26

@onready var tilemap = $"../TileMap"


func _on_area_2d_enter_body_exited(body: CharacterBody2D):
	var nav_layer = navigation_layer_name + "_" + str(from_layer) 
	_setting_all_layer(body, from_layer, nav_layer, true, false)


func _on_area_2d_exit_body_exited(body: CharacterBody2D):
	if body.is_in_group("Player"):
		used_stairs.emit(self)
	var nav_layer = navigation_layer_name + "_" + str(to_layer)
	_setting_all_layer(body, to_layer, nav_layer, false, true)


func _setting_all_layer(body, layer_position, nav_layer, is_active, is_next_active):
	var deco_level_id = tilemap.get_layer_id_by_name(deco_layer_name)
	tilemap.set_layer_z_index(deco_level_id, layer_position)
	
	_setting_body(body, layer_position, is_active, is_next_active)
	
	_setting_detection_area(body, is_active, is_next_active)
	
	_setting_hitbox_area(body,  is_active, is_next_active)
	
	_change_enemy_navigation_layer(body, nav_layer)


func _setting_hitbox_area(body, is_active, is_next_active):
	var hitbox_area: Area2D = body.get_node("HitboxComponent")
	var hitbox_area_position = body._base_damage_layer + (body._layer_position - 1)
	hitbox_area.set_collision_layer_value(hitbox_area_position - 1, is_active)
	hitbox_area.set_collision_mask_value(hitbox_area_position - 1, is_active)
	hitbox_area.set_collision_layer_value(hitbox_area_position, is_next_active)
	hitbox_area.set_collision_mask_value(hitbox_area_position, is_next_active)

func _setting_detection_area(body, is_active, is_next_active):
	var detection_area: Area2D
	if body.is_in_group("Player"):
		detection_area = body.get_node("DetectionComponent")
	if body.is_in_group("Enemy"):
		detection_area = body.get_node("DetectionAreaComponent")
		
	detection_area.set_collision_layer_value(detection_area_layer, is_active)
	detection_area.set_collision_mask_value(detection_area_layer, is_active)
	detection_area.set_collision_layer_value(detection_area_next_layer, is_next_active)
	detection_area.set_collision_mask_value(detection_area_next_layer, is_next_active)


func _setting_body(body, layer_position, is_active, is_next_active):
	body.z_index = layer_position
	body.set_layer_position(layer_position)
	body.set_collision_layer_value(from_layer, is_active)
	body.set_collision_mask_value(from_layer, is_active)
	body.set_collision_layer_value(to_layer, is_next_active)
	body.set_collision_mask_value(to_layer, is_next_active)


func _change_enemy_navigation_layer(enemy, nav_layer):
	if enemy.is_in_group("Enemy"):
		var nav: NavigationAgent2D = enemy.get_node("NavigationComponent")
		var nav_layer_id = tilemap.get_layer_id_by_name(nav_layer)
		nav.set_navigation_map(tilemap.get_navigation_map(nav_layer_id))
