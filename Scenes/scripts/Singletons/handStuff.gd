extends Node3D

const selectionDistance: float = 6
const handSpeed: float = 10
const handReach: float = 3.5
var isPinnedHand: bool = false
var rePinToggle: bool = false
var pinnedPosition: Vector3
var mouse: Vector3

func set_mouse(Value) -> void:
	mouse = Value

func set_rePinToggle(value: bool) -> void:
	rePinToggle = value

func set_isPinnedHand(value: bool) -> void:
	isPinnedHand = value

func set_pinnedPosition(value: Vector3) -> void:
	pinnedPosition = value

func throwRay(hand, camera):
	var rayOrigin: Vector3 = Vector3()
	var rayEnd: Vector3 = Vector3()
	var spaceState = hand.get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	
	rayOrigin = camera.project_ray_origin(mousePos)
	rayEnd = rayOrigin + camera.project_ray_normal(mousePos)*2000
	
	var Query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = spaceState.intersect_ray(Query)
	
	return intersection
