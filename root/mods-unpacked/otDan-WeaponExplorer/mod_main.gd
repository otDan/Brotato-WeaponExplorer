extends Node

const MOD_NAME = "otDan-WeaponExplorer"

var dir = ""
var translations_dir = ""
var extensions_dir = ""


func _init(_mod_loader):
	ModLoaderLog.info("Init", MOD_NAME)

	dir = ModLoaderMod.get_unpacked_dir() + MOD_NAME + "/"
	translations_dir = dir + "translations/"
	extensions_dir = dir + "extensions/"

	_install_translations()
	_install_script_extensions()
	_add_child_classes()


func _ready():
	ModLoaderLog.success("Loaded", MOD_NAME)


func _install_translations()->void:
	ModLoaderMod.add_translation(translations_dir + "weaponexplorer_translation.en.translation")


func _install_script_extensions():
	ModLoaderMod.install_script_extension(extensions_dir + "singletons/weapon_service.gd")
	ModLoaderMod.install_script_extension(extensions_dir + "ui/menus/title_screen/title_screen_menus.gd")
	ModLoaderMod.install_script_extension(extensions_dir + "ui/menus/pages/menu_choose_options.gd")
	ModLoaderMod.install_script_extension(extensions_dir + "ui/menus/run/character_selection.gd")
	ModLoaderMod.install_script_extension(extensions_dir + "ui/menus/run/weapon_selection.gd")


func _add_child_classes():
	var WeaponExplorer = load(dir + "weapon_explorer.gd").new()
	WeaponExplorer.name = "WeaponExplorer"
	add_child(WeaponExplorer)

	var WeaponStringComparer = load(dir + "global/string_comparer.gd").new()
	WeaponStringComparer.name = "WeaponStringComparer"
	add_child(WeaponStringComparer)
