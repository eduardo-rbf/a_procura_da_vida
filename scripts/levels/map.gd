extends Node2D

var current_layer = 0
var layers = Array()

func _ready():
	#instancing and using handmade maps are both valid options
	var first_layer = $Level_layer
	print(first_layer.z_index)
	layers.append(first_layer)
	var next_layer = first_layer.find_child("Level_layer")
	print(next_layer.z_index)
	while(next_layer):
		print(next_layer)
		print(next_layer.z_index)
		layers.append(next_layer)
		next_layer = next_layer.find_child("Level_layer")
		pass

func _on_player_layer_changed(layer: int) -> void:
	#assuming jump up
	#physics layer above "layer" becomes upper
	#add 0b10, remove 0b100
	#physics layer above upper becomes wall
	#add 0b100
	#physics layer below is disabled.
	#remove 0b1
	print("at:map.gd::_on_player_layer_changed()", "layer: ", layer)
	for map_layer: TileMapLayer in layers:
		if map_layer.z_index == (layer + 1): #physics layer above "layer" becomes wall
			#print("at:map.gd::_on_player_layer_changed()", "updating wall: ", map_layer.z_index)
			map_layer.tile_set.set_physics_layer_collision_layer(0, 3)
		elif map_layer.z_index == layer: #physics layer at "layer" becomes upper
			#print("at:map.gd::_on_player_layer_changed()", "updating upper: ", map_layer.z_index)
			map_layer.tile_set.set_physics_layer_collision_layer(0, 2)
		elif map_layer.z_index == (layer - 1): #physics layer below "layer" becomes walkable
			#print("at:map.gd::_on_player_layer_changed()", "updating ground: ", map_layer.z_index
			map_layer.tile_set.set_physics_layer_collision_layer(0, 1)
		else: #every other physics layer is disabled
			#print("at:map.gd::_on_player_layer_changed()", "updating: ", map_layer.z_index)
			map_layer.tile_set.set_physics_layer_collision_layer(0, 0)
	print("at:map.gd::_on_player_layer_changed()", "finished.")
