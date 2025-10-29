extends CharacterBody2D
class_name Player

const WATER_ELEMENT = preload("uid://bm0nfhtxr8et8")
const FIRE_ELEMENT = preload("uid://dirvbjxkn2pam")
const WIND_ELEMENT = preload("uid://duoekhjeg3c58")
const EARTH_ELEMENT = preload("uid://cikihy5ag5kj7")


## Format: [element resource, attack function, level]
var ELEMENTS : Array = [
	null,
	null,
	null,
	null
]

const SPEED = 50.0
var health = 100
var score = 0
var can_hit = true
@onready var sprite: AnimatedSprite2D = $sprite

@onready var hotbar = $hotbar
@onready var slot_1_timer = $slot1timer
@onready var slot_2_timer = $slot2timer
@onready var slot_3_timer = $slot3timer
@onready var slot_4_timer = $slot4timer

var element_abilities : ElementAbilities = ElementAbilities.new()


func setup():
	element_abilities.player = self
	add_child(element_abilities)
	health = 100
	score = 0
	update_stats()
	
	var starting_elements = [WATER_ELEMENT,FIRE_ELEMENT,WIND_ELEMENT,EARTH_ELEMENT]
	change_slot(1, WATER_ELEMENT)
	change_slot(2, FIRE_ELEMENT)
	change_slot(3, WIND_ELEMENT)
	change_slot(4, EARTH_ELEMENT)


func _physics_process(_delta: float) -> void:	
	Globals.player_elements = ELEMENTS
	
	var direction_x := Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("left"): sprite.flip_h = false
	if Input.is_action_just_pressed("right"): sprite.flip_h = true
	
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func update_stats():
	$"../level_ui/Control/VBoxContainer/score/score_label".text = str(score)
	$"../level_ui/Control/ProgressBar".value = health


func change_slot(slot_number : int, element : Element):

	
	ELEMENTS[slot_number - 1] = [element, Callable(element_abilities, element.function), 1]
	var slot_timer : Timer = get_node("slot" + str(slot_number) + "timer")
	slot_timer.wait_time = element.timer
	slot_timer.start()
	hotbar.element_slots[slot_number - 1].element = element
	hotbar.element_slots[slot_number - 1].element_level = 1


func level_up_slot(slot_number : int) -> void:
	ELEMENTS[slot_number - 1][2] += 1
	hotbar.element_slots[slot_number - 1].element_level += 1


func slot_timeout(slot_number : int) -> bool:
	if ELEMENTS[slot_number - 1]:
		ELEMENTS[slot_number - 1][1].call(ELEMENTS[slot_number - 1][2])
		return true
	else:
		return false

func slot1timeout() -> void:
	if slot_timeout(1):
		slot_1_timer.start()


func slot2timeout() -> void:
	if slot_timeout(2):
		slot_2_timer.start()


func slot3timeout() -> void:
	if slot_timeout(3):
		slot_3_timer.start()


func slot4timeout() -> void:
	if slot_timeout(4):
		slot_4_timer.start()


func _on_immunity_timer_timeout() -> void:
	can_hit = true
	$".."/level_ui/immunity.hide()
