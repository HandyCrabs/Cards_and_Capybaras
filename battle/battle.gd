extends Node2D

var deck := Pile.new()
var hand := Pile.new()
var discard := Pile.new()
var exhaust := Pile.new()
var max_hand : int = 5
var selected_card: Control = null

@onready var hand_container : Node2D = $HandContainer
@onready var card_scene = load("res://cards/card.tscn")
@onready var enemy : Enemy = $Enemy
@onready var player : Player = $Player

@export var starting_deck : Array[CardData]

const CARD_SIZE := Vector2(260, 382)
const FAN_RADIUS := 1500.0     # bigger = flatter arc
const FAN_SPREAD_DEG := 8.0    # degrees between adjacent cards

func _ready() -> void:
	deck.cards.assign(starting_deck)
	deck.shuffle()
	enemy.clicked.connect(_on_enemy_clicked)
	player.clicked.connect(_on_player_clicked)

func draw_card() -> void:
	if hand.card_count() + 1 <= max_hand:		#accounting for index 0
		var card := deck.draw()
		if card == null:
			print("Deck is empty!")
			return
		hand.add_card(card)
		var view :Control = card_scene.instantiate()
		view.clicked.connect(_on_card_clicked)
		view.card_data = card
		hand_container.add_child(view)
		_update_hand_layout()
	else:
		print("Your hand is full!")
		return

func _on_enemy_clicked(target: Enemy) -> void:
	if selected_card == null:
		return
	var card: CardData = selected_card.card_data
	if card.card_type != CardData.CardType.ATTACK:
		return
	if not player.spend_energy(card.card_cost):
		print("Not enough energy!")
		return
	target.take_damage(card.card_value)
	_discard(selected_card)

func _on_player_clicked(target: Player) -> void:
	if selected_card == null:
		return
	var card: CardData = selected_card.card_data
	if card.card_type != CardData.CardType.SKILL:
		return
	if not player.spend_energy(card.card_cost):
		print("Not enough energy!")
		return
	target.gain_block(card.card_value)
	_discard(selected_card)

func _on_card_clicked(view: Control) -> void:
	var was_selected := view == selected_card
	if selected_card:
		selected_card.set_selected(false)
	selected_card = null if was_selected else view
	if selected_card:
		selected_card.set_selected(true)

func _update_hand_layout() -> void:
	var views := hand_container.get_children()
	var count := views.size()
	for i in count:
		var view: Control = views[i]
		view.pivot_offset = CARD_SIZE / 2.0
		var offset := i - (count - 1) / 2.0
		var angle := deg_to_rad(offset * FAN_SPREAD_DEG)
		view.base_position = Vector2(sin(angle), 1.0 - cos(angle)) * FAN_RADIUS - CARD_SIZE / 2.0
		view.position = view.base_position
		view.rotation = angle

func _discard(view: Control) -> void:
	hand.remove_card(view.card_data)
	discard.add_card(view.card_data)
	hand_container.remove_child(view)
	view.queue_free()
	_update_hand_layout()
	print(discard.cards.map(func(c: CardData): return c.card_name))
