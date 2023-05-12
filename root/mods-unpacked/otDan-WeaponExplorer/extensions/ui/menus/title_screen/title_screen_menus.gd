extends "res://ui/menus/title_screen/title_screen_menus.gd"

onready var weapon_menu_choose_options = get_node("MenuChooseOptions")

var _menu_weapon_explorer


func _ready():
	_menu_weapon_explorer = load("res://mods-unpacked/otDan-WeaponExplorer/ui/menus/items/weapon_explorer.tscn").instance()
	add_child(_menu_weapon_explorer)
	_menu_weapon_explorer.visible = false
	_menu_weapon_explorer.connect("back_button_pressed", self, "weapon_explorer_back_button_pressed")
	weapon_menu_choose_options.connect("weapon_explorer_button_pressed", self, "weapon_explorer_button_pressed")


func back() -> void:
	.back()
	_menu_weapon_explorer.reset()


func weapon_explorer_button_pressed() -> void:
	switch(weapon_menu_choose_options, _menu_weapon_explorer)


func weapon_explorer_back_button_pressed() -> void:
	switch(_menu_weapon_explorer, weapon_menu_choose_options)
