extends MarginContainer

@onready var progress_bar: TextureProgressBar = $GoldProgressBar
@onready var label: Label = $GoldLabel


@onready var player: CharacterBody2D = get_tree().root.get_node("World/Player")

func _process(delta: float) -> void:
	label.text = str(player.gold, " / 5")
	progress_bar.value = player.gold
