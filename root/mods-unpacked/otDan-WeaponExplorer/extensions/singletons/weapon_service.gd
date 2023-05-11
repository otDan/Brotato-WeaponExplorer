extends "res://singletons/weapon_service.gd"


func manage_special_spawn_projectile(
	entity_from:Unit,
	p_weapon_stats: RangedWeaponStats,
	auto_target_enemy: bool,
	entity_spawner_ref: EntitySpawner,
	p_direction: float = rand_range( - PI, PI),
	damage_tracking_key:String = ""
) -> Node:
	if entity_from == null:
		return null
	if entity_spawner_ref == null:
		var pos = entity_from.global_position
		var weapon_stats = p_weapon_stats.duplicate()
		var direction = p_direction
		return WeaponService.spawn_projectile(
			direction,
			weapon_stats,
			pos,
			Vector2.ONE.rotated(direction),
			true,
			[],
			null,
			damage_tracking_key
		)
	return .manage_special_spawn_projectile(entity_from, p_weapon_stats, auto_target_enemy, entity_spawner_ref, p_direction, damage_tracking_key)
