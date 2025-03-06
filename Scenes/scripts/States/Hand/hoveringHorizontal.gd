extends State
class_name hoveringHorizontal

@onready var hand: Node3D = $".."
@onready var player: CharacterBody3D = hand.player
@onready var camera: Camera3D = hand.camera
@export var gwabing: grabing

#Visual Hand Stuff
var threshold: float = 2.0
var hand_reach: float = 3.5
var hand_speed: float = 10
var mouse: Vector3

#ray stuff
var point: Dictionary

func calculateVelocity() -> Vector3:
	var origin: Vector3 = Vector3(player.position.x,player.position.y,0)
	var magnitude: float = clamp(origin.distance_to(mouse), 0, handStuff.handReach)
	var angle: Vector3 = origin.direction_to(mouse)
	var point: Vector3 = origin+(angle * magnitude)
	var result: Vector3 = hand.position.direction_to(point)*(hand.position.distance_to(point)*handStuff.handSpeed)
	
	return result

func recievedCamera(pos) -> void:
	mouse = pos

func _ready() -> void:
	camera.mousePosition.connect(recievedCamera)

func Enter():
	pass

func Exit():
	pass

func Update(delta: float):
	point = handStuff.throwRay(hand, camera)
	if not point.is_empty():
		if point["collider"] is Item and player.position.distance_to(point["collider"].position) <= handStuff.selectionDistance:
			hand.on_child_transition(self, "hoveringObject")
		
		#unpin
	if Input.is_action_just_pressed("Mouse2") and handStuff.isPinnedHand == true:
		gwabing.cleanup()

func intigrateForces(state):
	var result: Vector3 = calculateVelocity()
	hand.set_linear_velocity(result)
	hand.set_rotation(Vector3(0,0,0))
