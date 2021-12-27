extends Node

var diamonds: int = 0

export(int) var health
export(int) var jump_damage
export(int) var ground_damage
export(int) var dagger_damage

func update_amount(type: String, amount: int) -> void:
	match type:
		"diamond":
			update_diamonds(amount)
			
		"heart":
			pass
			
			
func update_diamonds(amount: int) -> void:
	diamonds += amount
	Interface.photo_container.update_diamond_count(diamonds)
