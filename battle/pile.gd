class_name Pile
extends RefCounted

var cards: Array[CardData] = []

func shuffle() -> void:
	cards.shuffle()

func add_card(card: CardData) -> void:
	cards.append(card)

func draw() -> CardData:
	if cards.is_empty():
		return null
	else:
		return cards.pop_back()

func remove_card(card: CardData) -> void:
	cards.erase(card)

func card_count() -> int:
	var card_qty : int
	card_qty = cards.size()
	return card_qty

func move_all_to(target: Pile) -> void:
	target.cards.append_array(cards)
	cards.clear()
