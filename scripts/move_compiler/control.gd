extends TextureRect
 
@export var control_type: String = "left"

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.size = Vector2(64, 64)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	return {
		"type": control_type,
		"texture": texture
	}
 
 
func _can_drop_data(_pos, _data):
	return false
 
