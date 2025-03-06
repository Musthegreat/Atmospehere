extends RigidBody3D
class_name Item

const ItemScale: float = 0.1
@export var max_durability: int
@export var attachment_points: Array

var attachment_strength: Array
var joint_handle: PinJoint3D

func attach_to(item: Node3D):
	var joint = PinJoint3D.new()
	add_child(joint)
	joint.set_node_a(item.get_path())
	joint.set_node_b(get_path())
	joint_handle = joint
	
func let_go():
	joint_handle.queue_free()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	pass
	#look_at(handStuff.mouse)
