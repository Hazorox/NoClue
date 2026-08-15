class_name DamageReceiver
extends Area2D

enum HitType {NORMAL, KNOCKDOWN, POWER}

signal damage_received(damage: int, direction: Vector2, hit_type: HitType)

func receive_damage(amount: int, direction: Vector2, hit_type: HitType, attacker_owner: Node = null) -> void:
	if attacker_owner != null and attacker_owner == owner:
		return
	damage_received.emit(amount, direction, hit_type)
	if owner.has_method("on_receive_damage"):
		owner.on_receive_damage(amount, direction, hit_type)
