extends CanvasLayer

@onready var tbcont = $tbcontainer
@onready var label = $tbcontainer/MarginContainer/ColorRect/Label

enum state{READY, RUNNING, END}
var cur_state = state.READY
var queue = []
var tween = create_tween()

func _ready() -> void:
	hide_textbox()
	tqueue("I love pizza")
	tqueue("I love Hack Club")
	tqueue("I love Long Long")

func _process(delta: float) -> void:
	match cur_state:
		state.READY:
			if !queue.is_empty():
				add_txt()
		state.RUNNING:
			if Input.is_action_just_pressed("ui_accept"):
				change_stage(state.END)
				if tween and tween.is_running():
					tween.kill()
				label.visible_ratio = 1.0
		state.END:
			if Input.is_action_just_pressed("ui_accept"):
				change_stage(state.READY)
				if queue.is_empty():
					hide_textbox()
	
func hide_textbox():
	label.text = ""
	tbcont.hide()
	
func show_textbox():
	tbcont.show()
	label.text = "> "
	
func tqueue(x):
	queue.push_back(x)
	
func add_txt():
	change_stage(state.RUNNING)
	tbcont.show()
	
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
	if cur_state == state.RUNNING:
		change_stage(state.END)
	
func change_stage(next):
	cur_state = next
	match cur_state:
		state.READY:
			print("x")
		state.RUNNING:
			print("x")
		state.END:
			print("x")
		
