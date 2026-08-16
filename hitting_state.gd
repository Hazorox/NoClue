extends NodeState
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

func _ready() -> void:
	if hit_component_collision_shape:
		hit_component_collision_shape.disabled = true
		hit_component_collision_shape.position = Vector2(0, 0)

func _on_physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()

func _on_next_transitions() -> void:
	if animated_sprite_2d and not animated_sprite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	var prefix: String = get_tool_animation_prefix()

	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play(prefix + "_back")
		if hit_component_collision_shape:
			hit_component_collision_shape.position = Vector2(0, -18)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play(prefix + "_right")
		if hit_component_collision_shape:
			hit_component_collision_shape.position = Vector2(9, 0)
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play(prefix + "_front")
		if hit_component_collision_shape:
			hit_component_collision_shape.position = Vector2(0, 3)
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play(prefix + "_left")
		if hit_component_collision_shape:
			hit_component_collision_shape.position = Vector2(-9, 0)
	else:
		animated_sprite_2d.play(prefix + "_front")
		if hit_component_collision_shape:
			hit_component_collision_shape.position = Vector2(0, 3)

	if hit_component_collision_shape:
		hit_component_collision_shape.disabled = false

func _on_exit() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.stop()
	if hit_component_collision_shape:
		hit_component_collision_shape.disabled = true

func get_tool_animation_prefix() -> String:
	# Matches the tool enum to your AnimatedSprite2D animation names
	match player.current_tool:
		DataTypes.Tools.Sword:
			return "sword_hitting"
		_:
			return "chopping" # Default fallback (matches your axe/no-tool frames)
