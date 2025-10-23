extends Control

const project_color = Color.CRIMSON
const art_color = Color.GOLDENROD
const programming_color = Color.DARK_CYAN
const level_color = Color.VIOLET
const juice_color = Color.GREEN
const git_color = Color.SLATE_GRAY
const trello_color = Color.ORANGE

@export var projects : Array[Node]
@export var arts : Array[Node]
@export var programmers : Array[Node]
@export var levels : Array[Node]
@export var juices : Array[Node]
@export var gits : Array[Node]
@export var trellos: Array[Node]

func _ready() -> void:
	for project in projects: project.modulate = project_color
	for art in arts: art.modulate = art_color
	for programmer in programmers: programmer.modulate = programming_color
	for level in levels: level.modulate = level_color
	for juice in juices: juice.modulate = juice_color
	for git in gits: git.modulate = git_color
	for trello in trellos: trello.modulate = trello_color
