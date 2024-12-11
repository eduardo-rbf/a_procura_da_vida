extends Area2D

@onready var ray = $RayCast
@onready var animation_player = $Sprites/AnimationPlayer
var tile_size = 64
var rot = 0

var animation_speed = 0.5
var moving = false

var initial_position: Vector2
var initial_rotation: int

#input advance, turn_left, turn right
#isometric vectors either sqrt(3)/2:1/2 or 1:1/2 if dimetric
var direction_map = [
			{"rotation": "face_se", "movement": Vector2(1, 0.5), "walk": "walk_up"},
			{"rotation": "face_ne", "movement": Vector2(1, -0.5), "walk": "walk_right"},
			{"rotation": "face_nw", "movement": Vector2(-1, -0.5), "walk": "walk_down"},
			{"rotation": "face_sw","movement": Vector2(-1, 0.5), "walk": "walk_left"},
		]

#var inputs = [
#			"ui_left", #ccw
#			"ui_right", #cw
#			"ui_up" #advance
#]

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	position += direction_map[0]["movement"] * tile_size
	
	initial_position = position
	initial_rotation = rot
	pass

func reset_position():
	position = initial_position
	rot = initial_rotation
	animation_player.play(direction_map[rot]["rotation"])

func move(dir):
	match dir:
		"ui_up": 
			if !ray.is_colliding():
				var tween = create_tween()
				tween.tween_property(self, "position",
					position + direction_map[rot]["movement"] * tile_size / 2, animation_speed)
				moving = true
				animation_player.play(direction_map[rot]["walk"])
				await tween.finished
				moving = false
			else:
				return "fail"
		"ui_left":
			rot = wrap(rot - 1, 0, 4)
			animation_player.play(direction_map[rot]["rotation"])
		"ui_right":
			rot = wrap(rot + 1, 0, 4)
			animation_player.play(direction_map[rot]["rotation"])
		"jump":#test, movement arc, layer work(z)
			return "fail" #TODO
		"activate":#test, emit
			return "fail" #TODO
		"_": #unregistered command
			return "fail"
	
	ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	ray.force_raycast_update()
		
	return "ok"
