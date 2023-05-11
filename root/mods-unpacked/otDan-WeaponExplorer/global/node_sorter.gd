class_name WeaponExplorerNodeSorter
extends Node


func sort(a, b):
	return a.name < b.name


func reverse_sort(a, b):
	return a.name > b.name


func weapon_sort(weapon_a: WeaponData, weapon_b: WeaponData):
#	print("Name %s Tier %s, Name %s Tier %s" %[weapon_a.name, str(weapon_a.tier), weapon_b.name, str(weapon_b.tier)])

	if weapon_a.tier == weapon_b.tier:
		return tr(weapon_a.name) < tr(weapon_b.name)
	else:
		return weapon_a.tier < weapon_b.tier
