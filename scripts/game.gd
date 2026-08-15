extends Node
var finished :=false
var rooms_to_win :=7
var room :=1
@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("player")
