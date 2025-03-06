extends Node

@export var initialState: State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child: State in get_children():
		states[child.name.to_lower()] = child
		child.Transitioned.connect(on_child_transition)
		
		if initialState:
			initialState.Enter()
			current_state = initialState

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physicsUpdate(delta)

func _integrate_force(state):
	if current_state:
		current_state.intigrateForces(state)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var newState = states.get(new_state_name.to_lower())
	if !newState:
		return
	
	if current_state:
		current_state.Exit()
	
	newState.Enter()
	
	current_state = newState
