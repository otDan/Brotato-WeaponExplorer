extends Enemy


func _ready():
	init_current_stats()


func on_hurt() -> void:
	return


func get_knockback_value() -> Vector2:
	return Vector2(0, 0)


func set_entity_spawner(entity_spawner: EntitySpawner):
	_entity_spawner_ref = entity_spawner
