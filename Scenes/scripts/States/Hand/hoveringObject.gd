extends State
class_name hoveringObject

@onready var hand: Node3D = $".."
@onready var player: CharacterBody3D = hand.player
@onready var camera: Camera3D = hand.camera
var horizontal: hoveringHorizontal

var selectionSpeed: float = 15
var mouse: Vector3
var point: Dictionary

func _ready() -> void:
	camera.mousePosition.connect(recievedCamera)
	for child in hand.get_children():
		if child is hoveringHorizontal:
			horizontal = child

func recievedCamera(pos) -> void:
	mouse = pos

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	if Input.is_action_just_pressed("Mouse1") and point["collider"] is Item:
		hand.on_child_transition(self, "grabing")

func intigrateForces(state):
	point = handStuff.throwRay(hand, camera)
	if point and point["collider"] is Item and player.position.distance_to(point["collider"].position) <= handStuff.selectionDistance:
		var updated: Vector3 = Vector3(point["collider"].position.x,point["collider"].position.y+1,point["collider"].position.z)
		hand.set_linear_velocity((hand.position.distance_to(updated)*hand.position.direction_to(updated))*selectionSpeed)
		
	else:
		hand.on_child_transition(self, "hoveringHorizontal")
