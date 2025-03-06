extends Camera3D

var mouse: Vector3

signal mousePosition

@onready var space = get_viewport().world_3d.direct_space_state
@export var hand: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos: Vector2 = get_viewport().get_mouse_position()
	mouse = project_position(pos, position.z)
	mousePosition.emit(mouse)
	
	handStuff.mouse = mouse
