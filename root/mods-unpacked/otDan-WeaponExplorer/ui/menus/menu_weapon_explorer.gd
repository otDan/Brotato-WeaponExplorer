class_name WeaponExplorerMenu
extends Control

signal back_button_pressed

export (PackedScene) var mod_toggle
export (PackedScene) var character_toggle
export (PackedScene) var fake_player_scene
export (PackedScene) var weapon_toggle

onready var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
onready var WeaponExplorer = get_node("/root/ModLoader/otDan-WeaponExplorer/WeaponExplorer")
onready var StringComparer = get_node("/root/ModLoader/otDan-WeaponExplorer/WeaponStringComparer")

onready var content_explorer = $"%ContentExplorer"
onready var weapon_container = content_explorer.get_node("%ContentContainer")
onready var not_unlocked = content_explorer.get_node("%NotUnlocked")
onready var weapon_panel_ui = content_explorer.get_node("%ContentPanelUI")
onready var weapon_tags = content_explorer.get_node("%Tags")
onready var character_container = content_explorer.get_node("%CharacterContainer")
onready var start_run_button = content_explorer.get_node("%StartRunButton")

onready var mod_panel_container = content_explorer.get_node("%ModPanelContainer")
onready var mod_container = mod_panel_container.get_node("%ModContainer")

onready var weapon_preview_container = $"%WeaponPreviewContainer"
onready var _effects_manager = weapon_preview_container.get_node("%EffectsManager")
onready var _floating_text_manager = weapon_preview_container.get_node("%FloatingTextManager")
onready var entity_spawner: EntitySpawner = weapon_preview_container.get_node("%EntitySpawner")

onready var scene_holder = weapon_preview_container.get_node("%SceneHolder")
onready var dummy = weapon_preview_container.get_node("%Dummy")

var weapon_dictionary: Dictionary
var character_toggle_dictionary: Dictionary
var mod_weapons: Dictionary
var fake_player: Player

var visible_weapons: Dictionary
enum visible_keys {
	SEARCH,
	MOD_TOGGLE,
}


func _ready():
	var _size_changed = get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")

	connect_visual_effects(dummy)


func init() -> void:
	_on_viewport_size_changed()
	
	reset()

	var first_item: Button = null

	var sorter = load("res://mods-unpacked/otDan-WeaponExplorer/global/node_sorter.gd").new()
	var sorted_weapons = ItemService.weapons.duplicate()
	sorted_weapons.sort_custom(sorter, "weapon_sort")

	for weapon in sorted_weapons:
		var mod = ContentLoader.lookup_modid_by_itemdata(weapon)
		if mod == "CL_Notice-NotFound":
			mod = "Vanilla"
		else:
			mod = get_string_after_character(mod, "-")

		for key in visible_keys:
			if not visible_weapons.has(key):
				visible_weapons[key] = {}
			visible_weapons[key][weapon] = true

		var instance = weapon_toggle.instance()
		instance.set_weapon(weapon)
		instance.connect("weapon_toggle_focus_entered", self, "weapon_toggle_focus_entered")
		instance.connect("weapon_button_pressed", self, "weapon_button_pressed")
		weapon_container.add_child(instance)

		if not mod_weapons.has(mod):
			mod_weapons[mod] = []
		mod_weapons[mod].append(weapon)

		weapon_dictionary[weapon] = instance

		if first_item == null:
			first_item = instance.get_node("%ToggleButton")

	for character in ItemService.characters:
		var instance = character_toggle.instance()
		instance.set_character(character)
		instance.connect("character_button_pressed", self, "character_button_pressed")
		character_container.add_child(instance)
		character_toggle_dictionary[character] = instance

	for mod in mod_weapons.keys():
		var instance: CheckBox = mod_toggle.instance()
		var _mod_toggled = instance.connect("value_toggled", self, "on_value_toggled")
		mod_container.add_child(instance)
		instance.set_info(mod, mod_weapons[mod].size())

	first_item.grab_focus()


func reset() -> void:
	WeaponExplorer.selected_character = null
	start_run_button.disabled = true

	for child in weapon_container.get_children():
		weapon_container.remove_child(child)

	for child in mod_container.get_children():
		mod_container.remove_child(child)

	character_toggle_dictionary.clear()
	for child in character_container.get_children():
		character_container.remove_child(child)

	mod_weapons.clear()

	reset_fake_player()
	reset_dummy()
	
	
func full_reset() -> void:
	reset()
	delete_fake_player()


func get_string_after_character(a: String, character: String) -> String:
	var parts = a.split(character)
	if parts.size() > 1:
		return parts[1]
	else:
		return a


func weapon_toggle_focus_entered(weapon_data: WeaponData) -> void:
	WeaponExplorer.selected_character = null
	start_run_button.disabled = true
	weapon_panel_ui.set_data(weapon_data)

	reset_fake_player()
	reset_dummy()

	if weapon_data.type == WeaponData.Type.MELEE:
		fake_player.position = Vector2(120, 64)
		dummy.position = Vector2(240, 64)
	else:
		fake_player.position = Vector2(60, 64)
		dummy.position = Vector2(280, 64)

	if ProgressData.weapons_unlocked.has(weapon_data.weapon_id):
		not_unlocked.visible = false
		weapon_tags.visible = true

		var has_character = false
		for character in ItemService.characters:
			var _character: CharacterData = character
			var has_tag = false
			if _character.starting_weapons.has(weapon_data):
				has_tag = true
			character_toggle_dictionary[character].visible = has_tag

			if has_tag:
				has_character = true

		weapon_tags.visible = has_character
		fake_player.add_weapon(weapon_data, 1)
		return

	var weapon_description: ItemDescription = weapon_panel_ui._item_description
	weapon_description._name.text = "???"
	weapon_description._effects.visible = false
	weapon_description._effects_scrolled.visible = false
	weapon_description._weapon_stats.visible = false
	weapon_description._weapon_stats_scrolled.visible = false
	not_unlocked.visible = true
	weapon_tags.visible = false


func reset_fake_player() -> void:
	if not fake_player == null:
		fake_player.queue_free()
		
	fake_player = fake_player_scene.instance()
	scene_holder.add_child(fake_player)
	fake_player._entity_spawner_ref = entity_spawner
	connect_visual_effects(fake_player)
	
	
func delete_fake_player():
	if not fake_player == null:
		fake_player.queue_free()
	fake_player = null
	

func reset_dummy() -> void:
	dummy._entity_spawner_ref = entity_spawner
	dummy._burning = null
	dummy._burning_timer.stop()
	dummy._burning_particles.emitting = false
	dummy._burning_particles.deactivate_spread()
	dummy.init_current_stats()


func weapon_button_pressed(weapon: WeaponData) -> void:
	WeaponExplorer.selected_weapon = weapon

	for character_node in character_container.get_children():
		if character_node.visible:
			if not InputService.using_gamepad:
				var center = character_node.rect_global_position + (character_node.rect_size / 2)
				get_viewport().warp_mouse(center)

			character_node.get_node("%ToggleButton").grab_focus()
			return


func character_button_pressed(character: CharacterData)->void:
	if not ProgressData.characters_unlocked.has(character.my_id):
		return

	WeaponExplorer.selected_character = character

	if not InputService.using_gamepad:
		var center = start_run_button.rect_global_position + (start_run_button.rect_size / 2)
		get_viewport().warp_mouse(center)

	start_run_button.grab_focus()
	start_run_button.disabled = false


func on_mod_toggled(mod, state):
	for weapon in weapon_dictionary:
		var weapon_mod = ContentLoader.lookup_modid_by_itemdata(weapon)
		if weapon_mod == "CL_Notice-NotFound":
			weapon_mod = "Vanilla"
		else:
			weapon_mod = get_string_after_character(weapon_mod, "-")
		if not weapon_mod == mod:
			continue
		visible_weapons[visible_keys.keys()[visible_keys.MOD_TOGGLE]][weapon] = state
	handle_weapon_visiblity()


func _show_search_results(search: String):
	for child in weapon_container.get_children():
		var result = StringComparer._check_similarity(child.name.to_lower(), search.to_lower(), 1)
		if search == "":
			result = true
		visible_weapons[visible_keys.keys()[visible_keys.SEARCH]][child.weapon_data] = result
	handle_weapon_visiblity()


func handle_weapon_visiblity():
	for weapon in weapon_dictionary:
		var weapon_visible = true
		for key in visible_keys:
			if not visible_weapons[key][weapon]:
				weapon_visible = false
		var weapon_button = weapon_dictionary[weapon]
		weapon_button.visible = weapon_visible


func _on_viewport_size_changed():
	var weapons = int(round(get_viewport().get_visible_rect().size.x * 0.5 / 90))
	weapon_container.columns = weapons


func connect_visual_effects(unit:Unit) -> void:
	var _error_effects = unit.connect("took_damage", _effects_manager, "_on_unit_took_damage")
	var _error_floating_text = unit.connect("took_damage", _floating_text_manager, "_on_unit_took_damage")


func _on_BackButton_pressed() -> void:
	full_reset()
	emit_signal("back_button_pressed")


func _on_StartRunButton_pressed():
	if WeaponExplorer.selected_character == null:
		return

	MusicManager.tween(-5)
	var _error = get_tree().change_scene(MenuData.character_selection_scene)


func _on_Search_text_changed(search: String):
	_show_search_results(search)
