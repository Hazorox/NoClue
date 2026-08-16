extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		DialogueManager.tqueue("Meow! ".repeat(game.correct_door))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		DialogueManager.tqueue("Meow! ".repeat(game.correct_door))
