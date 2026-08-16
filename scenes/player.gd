class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None:
	set(value):
		current_tool = value
		if is_node_ready() and hit_component:
			hit_component.current_tool = value

var player_direction: Vector2 = Vector2.DOWN


func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	if hit_component:
		hit_component.current_tool = current_tool


func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = GameInputEvents.movement_input()
	if input_dir != Vector2.ZERO:
		player_direction = input_dir

func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = current_tool
