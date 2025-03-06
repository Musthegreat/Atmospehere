extends State
class_name grabing

@onready var hand: Node3D = $".."
@onready var player: CharacterBody3D = hand.player
@onready var camera: Camera3D = hand.camera

var mouse: Vector3
var point: Dictionary
var joint: PinJoint3D
var newJoint: PinJoint3D
var oldItem: Item
var item: Item

var scene = preload("res://Scenes/Player/pinnedHand.tscn")
var pinnedHand = RigidBody3D

func _ready() -> void:
	camera.mousePosition.connect(recievedCamera)

func recievedCamera(pos) -> void:
	mouse = pos

func calculateVelocity() -> Vector3:
	var origin: Vector3 = Vector3(player.position.x,player.position.y,0)
	var magnitude: float = clamp(origin.distance_to(mouse), 0, handStuff.handReach)
	var angle: Vector3 = origin.direction_to(mouse)
	var point: Vector3 = origin+(angle * magnitude)
	var result: Vector3 = hand.position.direction_to(point)*(hand.position.distance_to(point)*handStuff.handSpeed)
	
	return result

func firstPin() -> void:
	#create a position vector for the pinnedHand to follow
	var result: Vector3 = hand.position.distance_to(player.position) * hand.position.direction_to(player.position)
	handStuff.set_pinnedPosition(result * -1)
	
	#create the pinned hand
	pinnedHand = scene.instantiate()
	get_tree().current_scene.get_child(0).add_child(pinnedHand)
	pinnedHand.set_position(hand.position)
	
	#delete and recreate the joint
	joint.free()
	joint = PinJoint3D.new()
	pinnedHand.add_child(joint)
	joint.set_node_a(pinnedHand.get_path())
	joint.set_node_b(item.get_path())
	
	#update some variables
	oldItem = item
	handStuff.set_isPinnedHand(true)
	
	#escape
	hand.on_child_transition(self, "hoveringHorizontal")

func rePin() -> void:
	#use this to return to where the hand was during the repin
	var returnTo: Vector3 = pinnedHand.position
	
	#set mouse position to pinned hand
	var mousePos: Vector2 = get_viewport().get_camera_3d().unproject_position(pinnedHand.position)
	
	#cleaup the first pin
	joint.free()
	pinnedHand.free()
	if is_instance_valid(newJoint):
		newJoint.free()
	
	#create a position vector for the pinnedHand to follow
	var result: Vector3 = hand.position.distance_to(player.position) * hand.position.direction_to(player.position)
	handStuff.set_pinnedPosition(result * -1)
	
	#create the pinned hand
	pinnedHand = scene.instantiate()
	get_tree().current_scene.get_child(0).add_child(pinnedHand)
	pinnedHand.set_position(hand.position)
	
	#recreating the joint
	newJoint = PinJoint3D.new()
	pinnedHand.add_child(newJoint)
	newJoint.set_node_a(pinnedHand.get_path())
	newJoint.set_node_b(item.get_path())
	
	#move the mouse
	Input.warp_mouse(mousePos)
	
	#joint the old item with the hand
	hand.set_position(returnTo)
	joint = PinJoint3D.new()
	hand.add_child(joint)
	joint.set_node_a(hand.get_path())
	joint.set_node_b(oldItem.get_path())
	
	#update some variables
	oldItem = item
	item = get_node(joint.node_b)

func cleanup() -> void:
	if !Input.is_action_pressed("Mouse1"):
		handStuff.set_isPinnedHand(false)
		handStuff.set_rePinToggle(false)
		pinnedHand.free()
		if is_instance_valid(newJoint):
			newJoint.free()

func Enter():
	point = handStuff.throwRay(hand, camera)
	item = point["collider"]
	
	hand.set_position(point["position"])
	
	joint = PinJoint3D.new()
	hand.add_child(joint)
	
	joint.set_node_a(hand.get_path())
	joint.set_node_b(point["collider"].get_path())
	
	item.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_X, true)
	item.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_Y, true)

func Exit():
	pass

func Update(_delta: float):
	#let go of hand
	if Input.is_action_just_released("Mouse1"):
		item.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_X, false)
		item.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_Y, false)
		joint.free()
		hand.on_child_transition(self, "hoveringHorizontal")
		
		if handStuff.isPinnedHand == false:
			item.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_X, false)
			item.set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_Y, false)
		
	#unpin
	if Input.is_action_just_pressed("Mouse2") and handStuff.isPinnedHand == true:
		cleanup()
		
	if Input.is_action_just_pressed("Mouse2") and handStuff.isPinnedHand == true:
		rePin()
		
	#pin current hand amd bring out other hand
	if Input.is_action_just_pressed("Mouse2") and handStuff.isPinnedHand == false:
		firstPin()

func physicsUpdate(_delta: float):
	var origin: Vector3 = Vector3(player.position.x,player.position.y,0)
	var magnitude: float = origin.distance_to(mouse)
	var angle: Vector3 = origin.direction_to(mouse)
	item.look_at(mouse*2)
	hand.set_rotation(item.rotation)

func intigrateForces(state):
	var result: Vector3 = calculateVelocity()
	hand.set_linear_velocity(result)
