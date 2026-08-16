extends CanvasLayer

@onready var t_bcontainer: MarginContainer = $tbcontainer
@onready var label: Label = $tbcontainer/MarginContainer/ColorRect/Label

enum State { READY, RUNNING, END }
var cur_state = State.READY
var queue = []
var tween: Tween

func _ready() -> void:
	hide_textbox()

func _process(_delta: float) -> void:
	match cur_state:
		State.READY:
			if !queue.is_empty():
				add_txt()
		State.RUNNING:
			if Input.is_action_just_pressed("ui_accept"):
				cur_state = State.END
				if tween and tween.is_running():
					tween.kill()
				label.visible_ratio = 1.0
		State.END:
			if Input.is_action_just_pressed("ui_accept"):
				cur_state = State.READY
				if queue.is_empty():
					hide_textbox()

func hide_textbox() -> void:
	label.text = ""
	t_bcontainer.hide()

func tqueue(text: String) -> void:
	queue.push_back(text)

func add_txt() -> void:
	cur_state = State.RUNNING
	t_bcontainer.show()

	var next = queue.pop_front()
	label.text = "> " + next

	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, len(next) * 0.05)\
		.from(0.0)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	if cur_state == State.RUNNING:
		cur_state = State.END
