class_name Player
extends Character

#signal died(player_id: int)
signal health_changed(new_health: float)
signal combo_changed(player_id: int, count: int)

const REVIVE_HEIGHT := 80

@export_group("Combos")
@export var max_duration_between_succesful_hits : int


@onready var enemy_slots : Array = $EnemySlots.get_children()

var base_damage : int
var base_damage_power : int
var is_dodge_available := false
var is_raging := false
var time_since_last_succesful_attack := Time.get_ticks_msec()
var rage_meter := 0.0
var rage_end := 0.0
var opponent : Player = null
var prefix : String = ""

func _ready() -> void:
	super._ready()
	anim_attacks = ["punch", "punch_alt", "kick", "roundkick"]
	#DamageManager.player_revive.connect(on_player_revive.bind())
	base_damage = damage 
	base_damage_power = damage_power
	var anim_player = get_node("AnimationPlayer") as AnimationPlayer
	if anim_player and not anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void:
	if state != State.IDLE and state != State.WALK and state != State.JUMP:
		state = State.IDLE
		velocity = Vector2.ZERO

func _process(delta: float) -> void:
	super._process(delta)
	process_time_between_combos()
	handle_facing_opponent()

func handle_facing_opponent() -> void:
	if is_instance_valid(opponent) and velocity == Vector2.ZERO and can_move():
		if opponent.global_position.x < global_position.x:
			heading = Vector2.LEFT
		elif opponent.global_position.x > global_position.x:
			heading = Vector2.RIGHT
		set_heading()

func process_time_between_combos() -> void:
	if Time.get_ticks_msec() - time_since_last_succesful_attack > max_duration_between_succesful_hits:
		attack_combo_index = 0


func on_player_revive() -> void:
	current_health = max_health
	health_changed.emit(current_health)
	state = State.JUMP
	height = REVIVE_HEIGHT
	is_dodge_available = false

func on_emit_damage(receiver: DamageReceiver) -> void:
	super.on_emit_damage(receiver)
	time_since_last_succesful_attack = Time.get_ticks_msec()
	is_last_hit_successful = true
	combo_changed.emit(attack_combo_index + 1)

func on_receive_damage(amount: int, direction: Vector2, hit_type: DamageReceiver.HitType) -> void:
	super.on_receive_damage(amount, direction, hit_type)
	health_changed.emit(current_health)
	#if current_health <= 0:
		#died.emit(player)


func handle_input() -> void:
	if can_move():
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed
		if is_last_hit_successful:
				time_since_last_succesful_attack = Time.get_ticks_msec()
				attack_combo_index = (attack_combo_index + 1) % anim_attacks.size()
				is_last_hit_successful = false
		else:
				attack_combo_index = 0
	if can_jump() and Input.is_action_just_pressed("jump"):
		state = State.TAKEOFF
		attack_combo_index = 0

func set_heading() -> void:
	if can_move():
		if velocity.x > 0:
			heading = Vector2.RIGHT
		elif velocity.x < 0:
			heading = Vector2.LEFT

#func reserve_slot(enemy: BasicEnemy) -> EnemySlot:
	#var available_slots := enemy_slots.filter(
		#func(slot): return slot.is_free()
	#)
	#if available_slots.size() == 0:
		#return null
	#available_slots.sort_custom(
		#func(a: EnemySlot, b: EnemySlot):
			#var dist_a := (enemy.global_position - a.global_position).length()
			#var dist_b := (enemy.global_position - b.global_position).length()
			#return dist_a < dist_b
	#)
	#available_slots[0].occupy(enemy)
	#return available_slots[0]

#func free_slot(enemy: BasicEnemy) -> void:
	#var target_slots := enemy_slots.filter(
		#func(slot: EnemySlot): return slot.occupant == enemy
	#)
	#if target_slots.size() == 1:
		#target_slots[0].free_up()
