extends NodeState
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

func _ready() -> void:
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2(0, 0)

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	var prefix: String = get_tool_animation_prefix()

	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play(prefix + "_back")
		hit_component_collision_shape.position = Vector2(0, -18)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play(prefix + "_right")
		hit_component_collision_shape.position = Vector2(9, 0)
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play(prefix + "_front")
		hit_component_collision_shape.position = Vector2(0, 3)
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play(prefix + "_left")
		hit_component_collision_shape.position = Vector2(-9, 0)
	else:
		animated_sprite_2d.play(prefix + "_front")
		hit_component_collision_shape.position = Vector2(0, 3)

	hit_component_collision_shape.disabled = false

func _on_exit() -> void:
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true

func get_tool_animation_prefix() -> String:
	match player.current_tool:
		DataTypes.Tools.Sword:
			return "hitting"
		_:
			return "chopping" # Default fallback (axe / no tool)
