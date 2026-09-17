class_name CardData
extends Resource

enum DeckClass {CAPPY, SKUNK, MOLE}
enum CardType {ATTACK, SKILL, POWER}
enum CardKeyword {BURN, HOLD, QUICK, EVAPORATE}
enum CardRarity {COMMON, RARE, EPIC, LEGENDARY}

@export var deck_class: DeckClass
@export var card_type: CardType
@export var card_name: String
@export var card_description: String
@export var card_cost: int
@export var card_value: int
@export var card_keyword: CardKeyword
@export var card_rarity: CardRarity
@export var card_art: Texture2D
