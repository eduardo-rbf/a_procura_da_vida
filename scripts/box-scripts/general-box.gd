extends TextureRect
 
func _get_drag_data(at_position):
	var preview_texture = TextureRect.new()
 
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(70,70)
 
	var preview = Control.new()
	preview.add_child(preview_texture)
 
	set_drag_preview(preview)
	texture = null
 
	return preview_texture.texture
 
 
func _can_drop_data(_pos, data):
	return data is Texture2D
 

# 0 = Top
# 1 = Down
# 2 = Right
# 3 = Left
 
func _drop_data(_pos, data):
	texture = data
	
	var pos = name.to_int()  # Converte o nome do elemento em um número para 'pos'
	
	# Determina a direção (dir) com base no nome da textura
	var dir = -1
	match data.resource_path:
		"res://sprites/down-button.png":
			dir = 1  # Down
		"res://sprites/right-button.png":
			dir = 2  # Right
		"res://sprites/up-button.png":
			dir = 0  # Top
		"res://sprites/left-button.png":
			dir = 3  # left

	if dir != -1:
		var grid = get_parent().get_parent().get_node("Grid-mov")
		grid.addQuee(pos, dir)
