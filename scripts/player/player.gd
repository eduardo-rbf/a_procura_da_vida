extends Area2D

signal player_layer_changed(layer: int)
signal death

@onready var ground_ray = $GroundRay
@onready var upper_floor_ray = $UpperRay
@onready var wall_ray = $WallRay
@onready var animation_player = $Sprites/AnimationPlayer
var tile_size = 64
var displacement = 20
var rot = 0

var animation_speed = 0.5
var moving = false

var initial_position: Vector2
var initial_rotation: int

@export var start_coord: Vector2

var spam_guard = true

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
	#TODO: get inital position from level, spawn and reset there.
	
	#map slab height adjustment (+16(center) - 20(height))
	position.y = -4
	
	#							  vectors
	#							  se  sw
	#spawn position(hardcoded) at (2, 1)
	#	    (2 * 64 / 2, 1 * 64 / 2)+(-1 * 64 / 2, 0.5 * 64 / 2)
	#						(64, 32)+(-32, 16)
	#							 (32, 48)
	#position.x = 32
	#position.y += 48
	
	position += tile_size * (Vector2( start_coord.x, start_coord.x / 2) + 
							 Vector2(-start_coord.y, start_coord.y / 2)) / 2
	
	initial_position = position
	initial_rotation = rot
	pass

func reset_position():
	position = initial_position
	rot = initial_rotation
	animation_player.play(direction_map[rot]["rotation"])
	z_index = 1
	player_layer_changed.emit(z_index)
	ground_ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	upper_floor_ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	upper_floor_ray.target_position.y -= displacement
	wall_ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	wall_ray.target_position.y -= displacement * 2
	ground_ray.force_raycast_update()
	upper_floor_ray.force_raycast_update()
	wall_ray.force_raycast_update()

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
	print("[at:player.gd::_input()]",action, "->", await move(action))
	pass

func move(dir):
	#print("[at:player.gd::move()] ", 
	#"ground: ", ground_ray.is_colliding(), 
	#", upper: ", upper_floor_ray.is_colliding(), 
	#", wall: ", wall_ray.is_colliding())
	if(wall_ray.is_colliding()):
		print(wall_ray.get_collider())
		pass
	match dir:
		"advance": 
			advance()
		"turn_left", "turn_right":
			turn(dir)
		"jump":
			#if ground ahead and no upper or wall ahead
			if (ground_ray.is_colliding() and !upper_floor_ray.is_colliding()) or wall_ray.is_colliding():
				jump_in_place() 
			#else if no wall and no ground ahead
			elif !wall_ray.is_colliding():
				jump_forward()
		"activate":#test, emit
			return activate() #TODO
		"_": #unregistered command
			return "fail"
	
	#rotation, jumping
	ground_ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	upper_floor_ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	upper_floor_ray.target_position.y -= displacement
	wall_ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	wall_ray.target_position.y -= displacement * 2
	ground_ray.force_raycast_update()
	upper_floor_ray.force_raycast_update()
	wall_ray.force_raycast_update()
		
	return "ok"
	
func advance():
	if (ground_ray.is_colliding() and 
		!upper_floor_ray.is_colliding() and
		!wall_ray.is_colliding()): #walkable tile
			
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + direction_map[rot]["movement"] * tile_size / 2, animation_speed)
		moving = true
		animation_player.play(direction_map[rot]["walk"])
		await tween.finished
		moving = false
	else:
	#debug
		if ground_ray.is_colliding():
			print("[at:player.gd::advance()]", "Walkable tile")
			pass
		if upper_floor_ray.is_colliding() or wall_ray.is_colliding():
			print("[at:player.gd::advance()]", "Something blocks the way.")
		return "fail"
	
func turn(direction):
	match direction:
		"turn_left":
			rot = wrap(rot - 1, 0, 4)
			animation_player.play(direction_map[rot]["rotation"])
		"turn_right":
			rot = wrap(rot + 1, 0, 4)
			animation_player.play(direction_map[rot]["rotation"])

func jump_in_place():
	print("[at:player.gd::jump_in_place()]", "Player has jumped")
	#play animation, tween up and down.

func jump_forward():#ugh
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + upper_floor_ray.target_position, animation_speed)
	moving = true
	animation_player.play(direction_map[rot]["walk"])
	z_index += 1
	player_layer_changed.emit(z_index)
	await tween.finished
	moving = false
	await fall()
	ground_ray.target_position = direction_map[rot]["movement"] * tile_size / 2
	ground_ray.force_raycast_update()

func _physics_process(delta: float) -> void:
	if ground_ray.is_colliding() and !spam_guard:
		print("[at:player.gd::_physics_process()]", "ground")
		spam_guard = true
	elif !ground_ray.is_colliding() and spam_guard:
		print("[at:player.gd::_physics_process()]", "no ground")
		spam_guard = false

func fall():#no floor below after jump
	#try to collide with floor below
	ground_ray.target_position = Vector2(0, 0)
	while(!ground_ray.is_colliding()):
		if z_index <= 0: 
			death.emit()
			return "death"
		print("[at:player.gd::fall()]", "Not colliding with floor at layer ", z_index, ", falling further.")
		#print("[at:player.gd::fall()] ", 
		#"ground: ", ground_ray.is_colliding(), 
		#", upper: ", upper_floor_ray.is_colliding(), 
		#", wall: ", wall_ray.is_colliding())
		z_index -= 1
		player_layer_changed.emit(z_index)
		var tween = create_tween()
		tween.tween_property(self, "position",
			Vector2(position.x, position.y + 20), animation_speed / 2)
		moving = true
		await  tween.finished
		moving = false
		ground_ray.target_position = Vector2(0, 20)
		ground_ray.force_raycast_update()

func activate():
	return "TODO"
