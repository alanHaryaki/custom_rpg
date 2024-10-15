extends Resource

class_name AbilityData

enum AbilityName {BLEED, BLEED1, BLEED2, BLEED3, BLEED4, BLEED5, BLOCK, COUNTERACT, COUNTERACT2, DEFLECT, SLICE}

@export var ability_name: AbilityName
@export var conditions: Array[AbilityName]
@export_multiline var description: String
@export var ability_texture: Texture2D
