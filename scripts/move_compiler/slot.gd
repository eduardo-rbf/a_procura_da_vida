extends TextureRect

@export var row: int = 0
@export var col: int = 0

var grid: Array = []
var current_control: Variant = null

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.size = Vector2(64, 64)
	set_drag_preview(preview_texture)
	
	var dragged_control = current_control
	var dragged_texture = texture
	texture = null
	
	self._remove_control_from_grid()

	return {
		"type": dragged_control,
		"texture": dragged_texture
	}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("type")

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if typeof(data) == TYPE_DICTIONARY and data.has("type"):
		texture = data["texture"]
		current_control = data["type"]
		grid[row][col] = current_control

func _remove_control_from_grid() -> void:
	if current_control != null:
		texture = null
		grid[row][col] = null
		current_control = null
		
