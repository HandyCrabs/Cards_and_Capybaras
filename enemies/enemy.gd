class_name Enemy
extends Control

@export var data : EnemyData
var current_health: int

@onready var art: TextureRect = $Art
@onready var name_label: Label = $NameLabel
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_label: Label = $HealthLabel

signal clicked(enemy: Enemy)

func _ready() -> void:
	art.texture = data.art
	name_label.text = data.enemy_name
	health_bar.max_value = data.max_health
	current_health = data.max_health
	_update_health_display()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		clicked.emit(self)


func take_damage(amount: int) -> void:
	current_health = maxi(current_health - amount, 0)
	_update_health_display()

func _update_health_display() -> void:
	health_bar.value = current_health
	health_label.text = "%d / %d" % [current_health, data.max_health]
