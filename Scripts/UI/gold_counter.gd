extends MarginContainer

@onready var progress_bar: TextureProgressBar = $GoldProgressBar
@onready var label: Label = $GoldLabel

@onready var world: Node2D = get_tree().root.get_node("World")

func _process(delta: float) -> void:
	label.text = str(world.player.gold, " / ", Game.ability_price)
	progress_bar.value = world.player.gold
	check_gold()

func check_gold() -> void:
	if world.player.gold >= Game.ability_price:
		world.ability_selection_screen.display()
 
