extends Node
@onready var scoreLabel:Label = $contents/scoreControl/score
@onready var increaseScore:Button = $"contents/scoreControl/buttons/plus"
@onready var decreaseScore:Button = $"contents/scoreControl/buttons/minus"
@onready var verdict:Label = $contents/verdict
@onready var verdicts = ["SUCKER, BE STRONGER!!","That's too many T-T ( <20 )"]

func _ready()->void:
	scoreLabel.text = str(game.rooms_to_win)

func _on_minus_pressed() -> void:
	scoreLabel.text = str(int(scoreLabel.text) - 1)

func _on_plus_pressed() -> void:
		scoreLabel.text = str(int(scoreLabel.text) + 1)


func _on_start_pressed() -> void:
	if (int(scoreLabel.text) > 20):
		verdict.text = verdicts[1]
		verdict.visible=true
		return
	elif (int(scoreLabel.text)<5):
		verdict.text = verdicts[0]
		verdict.visible=true
		return
	else:
		verdict.visible=false
	game.rooms_to_win = int(scoreLabel.text)
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
