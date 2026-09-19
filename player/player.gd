class_name Player
extends Control

signal clicked(player: Player)

@export var max_health : int = 70
@export var max_energy : int = 3
var current_health : int
var block : int = 0
var energy: int

@onready var energy_label : Label = $EnergyLabel
@onready var health_bar : ProgressBar = $HealthBar
@onready var health_label : Label = $HealthLabel
@onready var block_label : Label = $BlockLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	energy = max_energy
	_update_display()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		clicked.emit(self)

func take_damage(amount: int) -> void:
	var absorbed := mini(block, amount)
	block -= absorbed
	current_health = maxi(current_health - (amount - absorbed),0)
	_update_display()

func spend_energy(amount: int) -> bool:
	if amount > energy:
		return false
	energy -= amount
	_update_display()
	return true


func refill_energy() -> void:
	energy = max_energy
	_update_display()

func gain_block(amount: int) -> void:
	block += amount
	_update_display()

func _update_display() -> void:
	health_bar.value = current_health
	health_label.text = "%d / %d" % [current_health, max_health]
	energy_label.text = "%d / %d" % [energy, max_energy]
	block_label.text = str(block)
	block_label.visible = block > 0
