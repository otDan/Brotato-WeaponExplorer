class_name WeaponToggle
extends PanelContainer

signal weapon_toggle_focus_entered(weapon_data)
signal weapon_button_pressed

const NOT_UNLOCKED_COLOR = Color(0, 0, 0, 0.25)
const NOT_UNLOCKED_DARK_COLOR = Color(0, 0, 0, 0.5)

onready var weapon_icon = $"%WeaponIcon"
onready var toggle_button = $"%ToggleButton"

var weapon_data: WeaponData

func _ready():
	if weapon_data == null:
		return

	name = tr(weapon_data.name)
	weapon_icon.texture = weapon_data.icon

	var stylebox_color: StyleBoxFlat = get_stylebox("panel").duplicate()
	ItemService.change_panel_stylebox_from_tier(stylebox_color, weapon_data.tier)
	add_stylebox_override("panel", stylebox_color)
	update_background_color()

	if ProgressData.weapons_unlocked.has(weapon_data.weapon_id):
		return

	toggle_button.disabled = true
	weapon_icon.self_modulate.a = 0.65


func set_weapon(_weapon_data: WeaponData):
	weapon_data = _weapon_data


func send_weapon():
	if weapon_data == null:
		return
	emit_signal("weapon_toggle_focus_entered", weapon_data)


func update_background_color(p_color:int = - 1) -> void:
	var stylebox_color: StyleBoxFlat = toggle_button.get_stylebox("normal").duplicate()
	change_inventory_element_stylebox_from_tier(stylebox_color, p_color if p_color != - 1 else weapon_data.tier, 0.35)
	toggle_button.add_stylebox_override("normal", stylebox_color)


func change_inventory_element_stylebox_from_tier(stylebox: StyleBoxFlat, tier: int, alpha: float = 1) -> void:
	var tier_color = ItemService.get_color_from_tier(tier)

	if tier_color == Color.white:
		tier_color = Color.black
		tier_color.a = 0.39
	else :
		tier_color.a = alpha

	stylebox.bg_color = tier_color


func _on_Button_focus_entered():
	send_weapon()


func _on_Button_mouse_entered():
	send_weapon()


func _on_ToggleButton_pressed():
	emit_signal("weapon_button_pressed", weapon_data)
