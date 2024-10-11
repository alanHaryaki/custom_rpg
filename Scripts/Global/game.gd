extends Node

var items := {
	0: preload("res://Scenes/Inventory/Item Resources/bow.tres"),
	1: preload("res://Scenes/Inventory/Item Resources/dagger.tres"),
	2: preload("res://Scenes/Inventory/Item Resources/potion.tres"),
	3: preload("res://Scenes/Inventory/Item Resources/sword.tres")
}

var item_equipped: ItemData = preload("res://Scenes/Inventory/Item Resources/bow.tres")
