extends Resource

class_name ItemData

enum Type {MELEE, RANGED, MISC, MAIN}
enum Effect {ARROW_SLICE, ARROW_DEFLECT, BLEED}
@export var type: Type
@export var item_name: String
@export var item_damage: int
@export var item_health: int
@export var item_defense: int
@export var item_effects: Array[Effect]
@export var stackable: bool
@export var count: int
@export_multiline var description: String
@export var item_texture: Texture2D
