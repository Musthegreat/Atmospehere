extends RigidBody3D
class_name Item

const ItemScale: float = 0.1
@export var max_durability: int
@export var attachment_points: Array

var attachment_strength: Array
var joint_handle: PinJoint3D

func _onready():
	set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Z, false)
	set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_Y, true)
	set_axis_lock(PhysicsServer3D.BODY_AXIS_ANGULAR_X, true)
	
func attach_to(item: Node3D):
	var joint = PinJoint3D.new()
	add_child(joint)
	joint.set_node_a(item.get_path())
	joint.set_node_b(get_path())
	joint_handle = joint
	
func let_go():
	joint_handle.queue_free()
