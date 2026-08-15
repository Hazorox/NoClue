class_name Character
extends CharacterBody2D

const GRAVITY := 600.0
const MAX_FLY_DURATION := 100

@export var can_respawn : bool
@export var damage : int
@export var damage_power : int
@export var max_health : int
@export var type : Type

@export_group("Movement")
@export var duration_grounded: float
@export var flight_speed : float
@export var jump_intensity : float
@export var knockback_intensity : float
@export var knockdown_intensity : float
@export var speed : float
@export var height : float
@export var height_speed : float

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharacterSprite
@onready var collateral_damage_emitter : Area2D = $CollateralDamageEmitter
@onready var collectible_sensor : Area2D = $CollectibleSensor
@onready var collision_shape := $CollisionShape2D
@onready var damage_emitter := $DamageEmitter
@onready var damage_receiver : DamageReceiver = $DamageReceiver
@onready var projectile_aim : RayCast2D = $ProjectileAim

enum State {IDLE, WALK, ATTACK, TAKEOFF, JUMP, LAND, HURT, FALL, DEATH}
enum Type {PLAYER}

var anim_attacks := []
var anim_map := {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.ATTACK: "punch",
	State.TAKEOFF: "takeoff",
	State.JUMP: "jump",
	State.LAND: "land",
	State.HURT: "hurt",
	State.FALL: "fall",
	State.DEATH: "death",
}

var attack_combo_index := 0
var current_health := 0
var fly_start := 0.0
var heading := Vector2.RIGHT
var is_last_hit_successful := false
var state := State.IDLE

func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_receiver.damage_received.connect(on_receive_damage.bind())
	collateral_damage_emitter.area_entered.connect(on_emit_collateral_damage.bind())
	collateral_damage_emitter.body_entered.connect(on_wall_hit.bind())
	set_health(max_health, type ==Character.Type.PLAYER)
	set_sprite_height_position()

func _process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	handle_air_time(delta)
	handle_prep_attack()
	handle_prep_shoot()
	handle_death(delta)
	set_heading()
	flip_sprites()
	set_sprite_height_position()
	setup_collisions()
	move_and_slide()


func set_sprite_height_position() -> void:
	character_sprite.position = Vector2.UP * height


func setup_collisions() -> void:
	collision_shape.disabled = is_collision_disabled()
	damage_emitter.monitoring = is_attacking()
	damage_receiver.monitorable = can_get_hurt()

func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK

func handle_input() -> void:
	pass

func handle_prep_attack() -> void:
	pass

func handle_prep_shoot() -> void:
	pass

func handle_death(delta: float) -> void:
	if state == State.DEATH and not can_respawn:
		modulate.a -= delta / 2.0
		if modulate.a <= 0:
			queue_free()

func handle_animations() -> void:
	if state == State.ATTACK:
		animation_player.play(anim_attacks[attack_combo_index])
	elif animation_player.has_animation(anim_map[state]):
		animation_player.play(anim_map[state])

func handle_air_time(delta: float) -> void:
	if [State.JUMP, State.FALL].has(state):
		height += height_speed * delta
		if height < 0:
			height = 0
			velocity = Vector2.ZERO
		else:
			height_speed -= GRAVITY * delta
		state = State.FALL
		height_speed = knockdown_intensity

func set_heading() -> void:
	pass

func flip_sprites() -> void:
	if heading == Vector2.RIGHT:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
		projectile_aim.scale.x = 1
	else:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1
		projectile_aim.scale.x = -1

func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK

func can_get_hurt() -> bool:
	return [State.IDLE, State.WALK, State.TAKEOFF, State.LAND].has(state)

func is_attacking() -> bool:
	return [State.ATTACK].has(state)


func can_pickup_collectible() -> bool:
	return false
	#if collectible.type == Collectible.Type.FOOD:
		#return true
	#return false

func pickup_collectible() -> void:
	pass


func is_collision_disabled() -> bool:
	return [State.DEATH].has(state)

func on_action_complete() -> void:
	state = State.IDLE

func on_takeoff_complete() -> void:
	state = State.JUMP
	height_speed = jump_intensity

func on_land_complete() -> void:
	state = State.IDLE

func on_receive_damage(amount: int, direction: Vector2, hit_type: DamageReceiver.HitType) -> void:
	if can_get_hurt():
		attack_combo_index = 0
		set_health(current_health - amount)
		if current_health == 0 or hit_type == DamageReceiver.HitType.KNOCKDOWN:
			state = State.FALL
			height_speed = knockdown_intensity
			velocity = direction * knockback_intensity
			#DamageManager.heavy_blow_recieved.emit()
		elif hit_type == DamageReceiver.HitType.POWER:
			velocity = direction * flight_speed
			fly_start = Time.get_ticks_msec()
			#DamageManager.heavy_blow_recieved.emit()
		else:
			state = State.HURT
			velocity = direction * knockback_intensity

func on_emit_damage(receiver: DamageReceiver) -> void:
	var hit_type := DamageReceiver.HitType.NORMAL
	var direction := Vector2.LEFT if receiver.global_position.x < global_position.x else Vector2.RIGHT
	var current_damage = damage
	if attack_combo_index == anim_attacks.size() - 1:
		hit_type = DamageReceiver.HitType.POWER
		current_damage = damage_power
	receiver.damage_received.emit(current_damage, direction, hit_type)
	is_last_hit_successful = true

func on_emit_collateral_damage(receiver: DamageReceiver) -> void:
	if receiver != damage_receiver:
		var direction := Vector2.LEFT if receiver.global_position.x < global_position.x else Vector2.RIGHT
		receiver.damage_received.emit(0, direction, DamageReceiver.HitType.KNOCKDOWN)

func on_wall_hit(_wall: AnimatableBody2D) -> void:
	state = State.FALL
	height_speed = knockdown_intensity
	velocity = -velocity / 2.0

func set_health(health: int, is_emitting_signal: bool = true) -> void:
	current_health = clamp(health, 0, max_health)
	#if is_emitting_signal:
		#DamageManager.health_change.emit(type, current_health, max_health)
