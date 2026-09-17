extends Control

@export var card_data: CardData

@onready var art: TextureRect = $Art
@onready var card_name: Label = $CardName
@onready var description: RichTextLabel = $Description
@onready var cost_container: HBoxContainer = $CostContainer
@onready var background : Panel = $Background

var base_position := Vector2.ZERO
var _tween: Tween
var is_selected := false

const CARROT_ICON := preload("res://cards/carrot.png")
const HOVER_LIFT : float = 60.0
const SELECT_LIFT := 120.0

signal clicked(card_view: Control)

func _ready() -> void:
	art.texture = card_data.card_art
	card_name.text = card_data.card_name
	description.text = card_data.card_description
	_populate_cost_icons()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if not is_selected:
		_tween_to(base_position + Vector2(0, -HOVER_LIFT))

func _on_mouse_exited():
	if not is_selected:
		_tween_to(base_position)

func _tween_to(target: Vector2) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "position", target, 0.1)

func _populate_cost_icons() -> void:
	for i in card_data.card_cost:
		var icon = TextureRect.new()
		icon.texture = CARROT_ICON
		icon.custom_maximum_size = Vector2(48, 48)
		cost_container.add_child(icon)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		clicked.emit(self)

func set_selected(value: bool) -> void:
	is_selected = value
	z_index = 1 if value else 0
	_tween_to(base_position + Vector2(0, -SELECT_LIFT) if value else base_position)
