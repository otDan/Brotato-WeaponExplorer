extends "res://projectiles/player_projectile.gd"


func bounce(thing_hit: Node) -> void:
	if thing_hit._entity_spawner_ref == null:
		return
	.bounce(thing_hit)
