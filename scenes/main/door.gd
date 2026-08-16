extends Area2D

var interactable:=false
@onready var transition_layer = $"../TransitionLayer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered",on_area_entered)
	self.connect("body_exited",on_area_exited)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and interactable:
		var door_num = self.name.right(1)
		game.advance(door_num==str(game.correct_door))
		transition_layer.flash_dim()
		
func on_area_entered(body:CharacterBody2D):
	interactable = true
func on_area_exited(body:CharacterBody2D):
	interactable=false
