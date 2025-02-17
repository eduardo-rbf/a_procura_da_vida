extends Area2D

signal death

@onready var ray_cast = $RayCast
@onready var animation_player = $Sprites/AnimationPlayer
var tile_size = 64
var displacement = 20
var rot = 0
var player_coord: Vector2

var animation_speed = 0.5
var moving = false

var initial_position: Vector3
var initial_rotation: int

#if modified, it resets. x y coordinate on map + z layer
@export var start_coord: Vector3
@export var start_rot: int
@export var map: Node2D

func query_tile(layer, coord):
	return map.get_layer_tile_solid(layer, coord)

var spam_guard = true

#input advance, turn_left, turn right
#isometric vectors either sqrt(3)/2:1/2 or 1:1/2 if dimetric
var direction_map = [
			{"rotation": "face_se", "movement": Vector2(1, 0.5), "walk": "walk_up"},
			{"rotation": "face_ne", "movement": Vector2(1, -0.5), "walk": "walk_right"},
			{"rotation": "face_nw", "movement": Vector2(-1, -0.5), "walk": "walk_down"},
			{"rotation": "face_sw","movement": Vector2(-1, 0.5), "walk": "walk_left"},
		]
		
	
#how to get the coordinate of the tile the player is facing?
#player_coord + - something in x or y depending on rotation
#direction | rotation | operation
#southeast | 0		  | x+
#northwest | 2		  | x-
#southwest | 3		  | y+
#northeast | 1		  | y-
var next_coord = [
	Vector2(1, 0),
	Vector2(0, -1),
	Vector2(-1, 0),
	Vector2(0, 1)
]

#var inputs = [
#			"ui_left", #ccw
#			"ui_right", #cw
#			"ui_up" #advance
#]

func _ready():
	player_coord = Vector2(start_coord.x, start_coord.y)
	position = coord_to_position(player_coord)
	rot = start_rot
	
	initial_position = Vector3(position.x, position.y, start_coord.z)
	initial_rotation = rot
	animation_player.play(direction_map[rot]["rotation"])
	
	#query tile under player
	#print(query_tile(z_index - 1, Vector2(start_coord.x, start_coord.y)))
	
	pass

func coord_to_position(coord):
	#map slab height adjustment (-20(height))
	#map tile center adjustment (+16, +32)
	#					  vectors
	#					  se+  sw+
	#spawn position at     (2, 1)
	#(2 * 64 / 2, 1 * 64 / 2)+(-1 * 64 / 2, 0.5 * 64 / 2)
	#				 (64, 32)+(-32, 16)
	#					  (32, 48)
	#position.x = 32
	#position.y += 48
	var pixel_postion = Vector2(tile_size/2, -displacement + tile_size/4)
	pixel_postion += tile_size * (Vector2( coord.x, coord.x / 2) + 
					 			  Vector2(-coord.y, coord.y / 2)) / 2
	return pixel_postion

func reset_position():
	player_coord = Vector2(start_coord.x, start_coord.y)
	position = coord_to_position(player_coord)
	rot = initial_rotation
	animation_player.play(direction_map[rot]["rotation"])
	z_index = initial_position.z
	ray_cast.target_position = direction_map[rot]["movement"] * tile_size / 2
	ray_cast.force_raycast_update()

func _input(event: InputEvent) -> void:
	if moving:
		return
	var action: String
	if event.is_action_pressed("ui_left"):
		action = "turn_left"
	if event.is_action_pressed("ui_right"):
		action = "turn_right"
	if event.is_action_pressed("ui_up"):
		action = "advance"
	if event.is_action_pressed("ui_accept"):
		action = "jump"
	if event is InputEventKey:
		if event.as_text() == 'F':
			fall()
	#print("[at:player.gd::_input()]",action, "->", await move(action))
	await move(action) #silent
	pass

func move(direction):
	match direction:
		"advance": 
			await advance()
		"turn_left", "turn_right":
			await turn(direction)
		"jump":
			await jump()
		"activate":#test, emit
			await activate() #TODO
		"_": #unregistered command, null
			return "fail"
	
	ray_cast.target_position = direction_map[rot]["movement"] * tile_size / 2
	ray_cast.force_raycast_update()	
	return "ok"
	
func advance():
	var target_coord = player_coord + next_coord[rot]
	#print("[at:player.gd::advance()]", "player coordinates: ", player_coord, 
	#			". Next tile coordinates: ", player_coord + next_coord[rot])
	#print(query_tile(z_index - 1, target_coord))
	if (query_tile(z_index - 1, target_coord) and 
		!( query_tile(z_index, target_coord) or query_tile(z_index + 1, target_coord) ) ):
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + direction_map[rot]["movement"] * tile_size / 2, animation_speed)
		moving = true
		animation_player.play(direction_map[rot]["walk"])
		await tween.finished	
		moving = false
		player_coord = target_coord
	else:
	#debug
		'''if query_tile(z_index - 1, target_coord):
			print("[at:player.gd::advance()]", "Walkable tile")
		if query_tile(z_index, target_coord) or query_tile(z_index + 1, target_coord):
			print("[at:player.gd::advance()]", "Something blocks the way.")'''
		return "fail"
	
func turn(direction):
	match direction:
		"turn_left":
			rot = wrap(rot - 1, 0, 4)
			animation_player.play(direction_map[rot]["rotation"])
		"turn_right":
			rot = wrap(rot + 1, 0, 4)
			animation_player.play(direction_map[rot]["rotation"])

func jump():
	var target_coord = player_coord + next_coord[rot]
	#if ground ahead and no upper or wall ahead
	if (query_tile(z_index - 1, target_coord) and !query_tile(z_index, target_coord) or 
		query_tile(z_index + 1, target_coord) ):
		jump_in_place() 
	#else if no wall and no ground ahead
	elif !query_tile(z_index + 1, target_coord):
		jump_forward()

func jump_in_place():
	print("[at:player.gd::jump_in_place()]", "Player has jumped")
	#play animation, tween up and down.

func jump_forward():
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + direction_map[rot]["movement"] * tile_size / 2 + Vector2(0, -20), animation_speed)
	moving = true
	animation_player.play(direction_map[rot]["walk"])
	z_index += 1
	await tween.finished
	moving = false
	player_coord += next_coord[rot]
	await fall()

############update logic
func fall():#no floor below after jump
	pass
	#try to collide with floor below
	#ray_cast.target_position = Vector2(0, 0)
	while(!query_tile(z_index - 1, player_coord)):
	#	print("[at:player.gd::fall()]", "Not colliding with floor at layer ", z_index, ", falling further.")
		if z_index <= 0: 
			death.emit()
			return "death"
			
		z_index -= 1
		var tween = create_tween()
		tween.tween_property(self, "position",
			Vector2(position.x, position.y + 20), animation_speed / 2)
		moving = true
		await  tween.finished
		moving = false

func activate():
	return "TODO"
