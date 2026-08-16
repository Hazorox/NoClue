extends Node
var finished :=false
var rooms_to_win :=7
var room :=1
var correct_door:int = 0
@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sound:AudioStreamPlayer = get_tree().get_first_node_in_group("rickroll")
func _process(_delta:float)->void:
	if room==rooms_to_win:
		sound.play()

func advance(success:bool)->void:
	get_tree().paused=true
	
	
	get_tree().paused=false
	if success:
		room+=1
	else:
		room=1
	correct_door = RandomNumberGenerator.new().randi_range(1,5)
	print("NEW CORRECT DOOR : ",correct_door)
