extends Node
var finished :=false
var rooms_to_win :=7
var room :=1
var correct_door:int = RandomNumberGenerator.new().randi_range(1,5)

func advance(success:bool)->void:
	var player:CharacterBody2D = get_tree().get_first_node_in_group("player")
	# Centering player once again
	player.global_position.x = 160
	player.global_position.y = 120
	if success:
		room+=1
	else:
		room=1
	correct_door = RandomNumberGenerator.new().randi_range(1,5)
