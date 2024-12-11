extends Control
@onready var texture_node: TextureRect = $TextureRect
@export var texture: Texture2D

func _get_drag_data(_at_position):
	
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_node.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(70,70)
	preview_texture.z_index = 102
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	texture_node.texture = null
	
	return preview_texture.texture

func _can_drop_data(_pos, data):
	return data is Texture2D

func _drop_data(_pos, data):
	texture_node.texture = data

func reset() -> void:
	texture_node.texture = null

func get_action() -> String:
	if texture_node.texture:
		match texture_node.texture.resource_path: #for now
			"res://sprites/commands/up_btn.png": return "ui_up"
			"res://sprites/commands/right_btn.png": return "ui_right"
			"res://sprites/commands/left_btn.png": return "ui_left"
			"res://sprites/commands/Actions-go-jump-icon.png": return "jump"
			"res://sprites/commands/Signal-icon.png": return "activate"
	return "null"
