extends "res://ui/menus/pages/menu_choose_options.gd"


signal weapon_explorer_button_pressed


func _ready():
	var weapon_explorer_button = Button.new()
	weapon_explorer_button.name = "WeaponExplorer"
	weapon_explorer_button.text = "Weapons"
	weapon_explorer_button.connect("pressed", self, "weapon_explorer_button_pressed")
	weapon_explorer_button.set_script(preload("res://ui/menus/global/my_menu_button.gd"))
	var buttons = get_child(0)
	buttons.add_child(weapon_explorer_button)
	buttons.move_child(weapon_explorer_button, buttons.get_child_count() - 2)


func weapon_explorer_button_pressed():
	emit_signal("weapon_explorer_button_pressed")
