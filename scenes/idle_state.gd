extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D


func _on_enter() -> void:
	if animated_sprite_2d:
		if player.player_direction == Vector2.UP:
			animated_sprite_2d.play("idle_back")
		elif player.player_direction == Vector2.RIGHT:
			animated_sprite_2d.play("idle_right")
		elif player.player_direction == Vector2.DOWN:
			animated_sprite_2d.play("idle_front")
		elif player.player_direction == Vector2.LEFT:
			animated_sprite_2d.play("idle_left")
		else:
			animated_sprite_2d.play("idle_front")


func _on_physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()


func _on_next_transitions() -> void:
	if GameInputEvents.use_tool():
		transition.emit("Hitting")
		return

	if GameInputEvents.is_movement_input():
		transition.emit("Walk")
