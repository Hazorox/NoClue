extends Node

var room :=1
var rooms_to_win :=12
var finished :=false
@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("player")
