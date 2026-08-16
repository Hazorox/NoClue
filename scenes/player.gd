class_name Player
extends CharacterBody2D


var player_direction: Vector2 = Vector2.DOWN




func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = GameInputEvents.movement_input()
	if input_dir != Vector2.ZERO:
		player_direction = input_dir
