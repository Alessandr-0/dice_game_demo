extends Node


@export var dice_1: Control
@export var dice_2: Control
@export var dice_3: Control
@export var dice_4: Control
@export var dice_5: Control
@export var dice_6: Control
@export var confetti: CanvasLayer

var my_defined_array: Array
var my_collected_array: Array
var my_sorted_array: Array


func _ready() -> void:
	confetti.visible = false


func _on_button_player_pressed() -> void:
	print("button pressed")
	SignalBus.si_player_button_was_pressed.emit()
	await get_tree().create_timer(0.3).timeout
	SignalBus.si_dice_rolled.emit()


## TESTING: Use keyboard input only for playtesting and debugging
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("test_d"):
		_define_arrays()
	if Input.is_action_just_pressed("test_s"):
		camera_effect(2.0, 5.0)
	if Input.is_action_just_pressed("test_c"):
		if not confetti.visible:
			_confetti()
		else:
			pass
	if Input.is_action_just_pressed("ui_cancel"):
		SignalBus.si_game_quit.emit()
		await get_tree().create_timer(0.5).timeout
		get_tree().quit.call_deferred()


## TODO: deze moet dus een arg uitspuwen dus niet void
func _define_arrays() -> Array:
	my_defined_array = [1,2,3]
	print(my_defined_array)
	_collecting_values()
	return my_defined_array


func _collecting_values() -> Array:
	my_collected_array = my_defined_array + [4,5,4]
	print(my_collected_array)
	_sorting_values()
	return my_collected_array


func _sorting_values() -> Array:
	my_sorted_array = my_collected_array + [3,2,1]
	print(my_sorted_array)
	return my_sorted_array


func _comparing_values_and_scoring():
	pass


func _confetti() -> void:
	confetti.visible = true
	await get_tree().create_timer(1.1).timeout
	confetti.visible = false


# INFO: For convenience made into dedicated function
func camera_effect(shake_duration = null, shake_strength = null) -> void:
	ScreenShaker2D.instance.shake(shake_duration, shake_strength)
