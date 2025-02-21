extends Node2D

var current_layer = 0
var layers = Array()

func _ready():
	#instancing and using handmade maps are both valid options
	var first_layer = $Level_layer
	
	layers.append(first_layer) #layer 0
	first_layer.z_index = 0
	var next_layer = first_layer.find_child("Level_layer")
	while(next_layer): #every layer between floor and any other must be occupied even if empty
		layers.append(next_layer)
		next_layer = next_layer.find_child("Level_layer")
		pass
	#instance player, trigger layers update

#just in case
func _on_player_layer_changed(_layer: int) -> void:
	pass

##existing tiles can be checked with
##get_cell_tile_data(Vector2(x,y))
##non existing tiles will be null
##the properties of tiles can be accessed with tile.get_custom_data
func get_layer_tile_solid(layer: int, tile: Vector2) -> bool:
	if layer >= 0 and layer < layers.size():
		return is_instance_valid(layers[layer].get_cell_tile_data(tile))
	return false

#TileData.get_custom_data("property as in the TileSet config under the TileMapLayer UI")
#can be used to identify tiles and react accordingly
#as in, triggering the end of the level
