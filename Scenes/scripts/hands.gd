extends Node3D

@export var player: CharacterBody3D
@export var camera: Camera3D

@export var initialState: State

var current_state: State
var oldState: State = initialState
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
		
	if initialState:
		current_state = initialState
		initialState.Enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physicsUpdate(delta)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if current_state:
		current_state.intigrateForces(state)

func on_child_transition(state, new_state_name):
	
	if state != current_state:
		print("state transition error: did not supply correct state", self)
		return
		
	var newState = states.get(new_state_name.to_lower())
	if !newState:
		print("state transition error: the new state name supplied does not match any children ", current_state)
		return
	
	if current_state:
		current_state.Exit()
	
	newState.Enter()
	
	oldState = current_state
	current_state = newState
