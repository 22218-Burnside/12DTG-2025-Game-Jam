extends Node

@onready var element_slot_1: Button = $"../player/hotbar/Control/VBoxContainer/MarginContainer/split/left/Element Slot1"
@onready var element_slot_2: Button = $"../player/hotbar/Control/VBoxContainer/MarginContainer/split/left/Element Slot2"
@onready var element_slot_3: Button = $"../player/hotbar/Control/VBoxContainer/MarginContainer/split/right/Element Slot3"
@onready var element_slot_4: Button = $"../player/hotbar/Control/VBoxContainer/MarginContainer/split/right/Element Slot4"
@onready var new_element: Control = $"../new_element/new_element"
@onready var player: Player = $"../player"

var queued_new_element

func slot1_selected(): 
	element_slot_1.element = queued_new_element
	player.change_slot(1,queued_new_element)
	
func slot2_selected(): 
	element_slot_2.element = queued_new_element
	player.change_slot(2,queued_new_element)
	
func slot3_selected(): 
	element_slot_3.element = queued_new_element
	player.change_slot(3,queued_new_element)
	
func slot4_selected(): 
	element_slot_4.element = queued_new_element
	player.change_slot(4,queued_new_element)

func disable_element_slots():

	element_slot_1.disabled = true
	element_slot_2.disabled = true
	element_slot_3.disabled = true
	element_slot_4.disabled = true
	
	new_element.hide()
	get_tree().paused = false
