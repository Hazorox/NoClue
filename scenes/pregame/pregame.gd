extends Node
@onready var scoreLabel:Label = $contents/scoreControl/score
@onready var increaseScore:Button = $"contents/scoreControl/buttons/plus"
@onready var decreaseScore:Button = $"contents/scoreControl/buttons/minus"
@onready var verdicts = ["SUCKER, BE STRONGER!!","Too many T-T <20"]
@onready var start = $contents/start
func _ready()->void:
	scoreLabel.text = str(game.rooms_to_win)

func _on_minus_pressed() -> void:
	scoreLabel.text = str(int(scoreLabel.text) - 1)

func _on_plus_pressed() -> void:
		scoreLabel.text = str(int(scoreLabel.text) + 1)


func _on_start_pressed() -> void:
	if (int(scoreLabel.text) > 20):
		start.text = verdicts[1]
		return
	elif (int(scoreLabel.text)<5):
		start.text = verdicts[0]
		return
	game.rooms_to_win = int(scoreLabel.text)
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
