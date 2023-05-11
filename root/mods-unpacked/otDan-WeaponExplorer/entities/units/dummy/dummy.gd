extends Enemy


func _ready():
	init_current_stats()


func on_hurt() -> void:
	return


func get_knockback_value() -> Vector2:
	return Vector2(0, 0)


func set_entity_spawner(entity_spawner: EntitySpawner):
	_entity_spawner_ref = entity_spawner
#func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0) -> Array:
#	var damage = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale)
#	print("Damage: %s" % str(damage))
#	return [0, 0]
