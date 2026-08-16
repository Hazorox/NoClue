class_name NodeStateMachine
extends Node
@export var initial_node_state: NodeState
var node_states: Dictionary = {}
var current_node_state: NodeState
var current_node_state_name: String

func _ready() -> void:
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
	if initial_node_state:
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name.to_lower()
		current_node_state._on_enter()

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)
		current_node_state._on_next_transitions()

func _process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)

func transition_to(node_state_name: String) -> void:
	var target_key: String = node_state_name.to_lower()
	if current_node_state and target_key == current_node_state.name.to_lower():
		return
	var new_node_state: NodeState = node_states.get(target_key)
	if not new_node_state:
		push_warning("State machine does not contain state: " + node_state_name)
		return
	if current_node_state:
		current_node_state._on_exit()
	new_node_state._on_enter()
	current_node_state = new_node_state
	current_node_state_name = target_key
