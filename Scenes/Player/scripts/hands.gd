extends RigidBody3D

var GLOBAL_DISTANCE: float = 0
@export var PLAYER: CharacterBody3D
@onready var test = $Sprite3D
@export var hand_reach: float = 3.5
@export var hand_speed: float = 8
var grab: bool = false
var grabbing: Item
var mouse_held: bool = false

func ScreenPointToRay():
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_tree().get_root().get_camera_3d()
	var origin = camera.project_ray_origin(mousePos)
	var normal = origin + camera.project_ray_normal(mousePos) * 100
	
	var query = PhysicsRayQueryParameters3D.create(origin, normal)
	query.collide_with_areas = true
	query.set_collision_mask(2)
	
	var result = spaceState.intersect_ray(query)
	
	if result.has("position"):
		return result["position"]
		
	return Vector3()

func _on_area_3d_body_entered(body):
	
	if body is Item:
		grabbing = body
		if Input.is_action_pressed("Mouse1"):
			if grab == false and mouse_held == true:
				grab = true
				body.attach_to(self)

func _integrate_forces(_state):
	var target_position = PLAYER.position
	target_position.z = GLOBAL_DISTANCE;
	var mouse = ScreenPointToRay()
	var distance = PLAYER.position.distance_to(mouse)
	var target_vector = PLAYER.position.direction_to(mouse)*clampf(distance, 0, hand_reach)
	set_linear_velocity(position.direction_to(target_position+target_vector)*(position.distance_to(target_vector)*hand_speed))

func _process(_delta):
	# CHANGES HAND LAYER
	#if Input.is_action_just_pressed("Mouse1") == true: # IS PUSHING
		#set_collision_layer_value(1, true)
		#set_collision_mask_value(1, true)
	#elif Input.is_action_just_released("Mouse1") == true: # IS NOT PUSHING
		#set_collision_layer_value(1, false)
		#set_collision_mask_value(1, false)
	
	if Input.is_action_pressed("Mouse1") == true:
		mouse_held = true
	else: 
		mouse_held = false

	if Input.is_action_just_released("Mouse1") and grab == true:
		grab = false
		grabbing.let_go()
