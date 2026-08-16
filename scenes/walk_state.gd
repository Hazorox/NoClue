extends NodeState
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: float = 100.0

func _on_physics_process(_delta: float) -> void:
	var input_dir: Vector2 = GameInputEvents.movement_input()
	player.velocity = input_dir * speed
	player.move_and_slide()

	if animated_sprite_2d:
		if input_dir == Vector2.UP:
			animated_sprite_2d.play("walk_back")
		elif input_dir == Vector2.RIGHT:
			animated_sprite_2d.play("walk_right")
		elif input_dir == Vector2.DOWN:
			animated_sprite_2d.play("walk_front")
		elif input_dir == Vector2.LEFT:
			animated_sprite_2d.play("walk_left")
		# NOTE: if input_dir == Vector2.ZERO, we intentionally leave the last
		# frame playing here. The Idle state's _on_enter() is responsible for
		# stopping/switching the sprite once the transition below fires.

func _on_next_transitions() -> void:
	if GameInputEvents.use_tool():
		transition.emit("Hitting")
		return
	if not GameInputEvents.is_movement_input():
		transition.emit("Idle")
