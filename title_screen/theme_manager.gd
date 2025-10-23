extends Control

const THEME = preload("uid://h22edabrcqwn")

const HEADER_FONT_SIZE := 32.0
const OUTLINE_SIZE := 8.0
const TEXT_FONT_SIZE := 16.0
const BUTTON_FONT_SIZE := 16

var ui_scale = 1

func _process(delta: float) -> void:
	ui_scale = Settings.ui_scale

func update():
	var const_offset = (get_viewport_rect().size.x / 640)
	
	theme = THEME
	theme.set_font_size("font_size", "Label", ui_scale * TEXT_FONT_SIZE * const_offset)
	theme.set_font_size("normal_font_size", "RichTextLabel", ui_scale * HEADER_FONT_SIZE * const_offset)
	theme.set_font_size("font_size", "Button", ui_scale * BUTTON_FONT_SIZE * const_offset)

	theme.set_constant("outline_size", "Label", ui_scale * OUTLINE_SIZE * const_offset)
	theme.set_constant("outline_size", "RichTextLabel", ui_scale * OUTLINE_SIZE * const_offset)
	theme.set_constant("outline_size", "Button", ui_scale * OUTLINE_SIZE * const_offset)
