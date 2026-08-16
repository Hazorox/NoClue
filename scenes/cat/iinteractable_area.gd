extends Area2D

@onready var dialogue = %Dialogue

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		dialogue.tqueue("Meow! I'm a talking cat.")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		dialogue.tqueue("Meow! I'm a talking cat.")

func _on_area_exited(_area: Area2D) -> void:
	pass

func _on_body_exited(_body: Node2D) -> void:
	pass
