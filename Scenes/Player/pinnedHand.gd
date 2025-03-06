extends RigidBody3D

@onready var player: CharacterBody3D = get_tree().current_scene.get_node("Game/Player")
var point: Vector3 = handStuff.pinnedPosition

# Called when the node enters the scene tree for the first time.b n bnbbc	     
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var result: Vector3 = point + player.position
	set_linear_velocity((position.distance_to(result)*handStuff.handSpeed)*position.direction_to(result))
