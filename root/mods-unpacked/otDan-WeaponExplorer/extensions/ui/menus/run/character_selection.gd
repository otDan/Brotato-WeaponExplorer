extends "res://ui/menus/run/character_selection.gd"

onready var WeaponExplorer = get_node("/root/ModLoader/otDan-WeaponExplorer/WeaponExplorer")


func _ready():
	var selected_character = WeaponExplorer.selected_character
	if selected_character == null:
		return
	for element in _inventory.get_children():
		if element.item == null:
			continue
		if element.item.my_id == selected_character.my_id:
			element._on_InventoryElement_pressed()
			WeaponExplorer.selected_character = null
