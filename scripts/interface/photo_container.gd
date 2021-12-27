extends Control

onready var diamond_label: Label = get_node("ContainerTexture/DiamondCount")

func _ready() -> void:
	diamond_label.text = "0000"
	
	
func update_diamond_count(new_amount: int) -> void:
	if new_amount < 10:
		diamond_label.text = "000" + str(new_amount)
	elif new_amount < 100 and new_amount > 10:
		diamond_label.text = "00" + str(new_amount)
	elif new_amount < 1000 and new_amount > 100:
		diamond_label.text = "0" + str(new_amount)
