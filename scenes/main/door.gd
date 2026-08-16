extends Area2D

var interactable:=false
@onready var transition_layer = $"../TransitionLayer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_area_entered)
	body_exited.connect(on_area_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and interactable:
		var door_num = self.name.right(1)
		game.advance(door_num==str(game.correct_door))
		await transition_layer.flash_dim(2)
		
func on_area_entered(body:CharacterBody2D):
	interactable = true
func on_area_exited(body:CharacterBody2D):
	interactable=false
