extends "res://ui/menus/run/weapon_selection.gd"

onready var WeaponExplorer = get_node("/root/ModLoader/otDan-WeaponExplorer/WeaponExplorer")


func _ready():
	var selected_weapon = WeaponExplorer.selected_weapon
	if selected_weapon == null:
		return
	for element in _inventory.get_children():
		if element.item == null:
			continue
		if element.item.weapon_id == selected_weapon.weapon_id:
			element._on_InventoryElement_pressed()
			WeaponExplorer.selected_weapon = null
