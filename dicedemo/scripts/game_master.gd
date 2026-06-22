extends Node


@export var dice_1: Control
@export var dice_2: Control
@export var dice_3: Control
@export var dice_4: Control
@export var dice_5: Control
@export var dice_6: Control
@export var confetti: CanvasLayer

var player_array: Array[int]
var enemy_array: Array[int]
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
		_fill_player_array()
		_fill_enemy_array()
	if Input.is_action_just_pressed("test_s"):
		camera_effect(1.0, 2.0)
		_comparing_values_and_scoring()
	if Input.is_action_just_pressed("test_c"):
		if not confetti.visible:
			_confetti()
		else:
			pass
	if Input.is_action_just_pressed("ui_cancel"):
		SignalBus.si_game_quit.emit()
		await get_tree().create_timer(0.5).timeout
		get_tree().quit.call_deferred()


## CAUTION: als het maar werkt voor nu
func _fill_player_array() -> Array:
	player_array = [dice_1.dice_result,dice_2.dice_result,dice_3.dice_result]
	print("unsorted P: ", player_array)
	_sort_player_array()
	return player_array

func _fill_enemy_array() -> Array:
	enemy_array = [dice_4.dice_result,dice_5.dice_result,dice_6.dice_result]
	print("unsorted E: ", enemy_array)
	_sort_enemy_array()
	return enemy_array


func _sort_player_array() -> Array:
	player_array.sort()
	print("sorted P: ", player_array)
	var p1 = player_array.get(0)
	var p2 = player_array.get(1)
	var p3 = player_array.get(2)
	dice_1.dice_result = p1
	dice_2.dice_result = p2
	dice_3.dice_result = p3
	return player_array

func _sort_enemy_array() -> Array:
	enemy_array.sort()
	print("sorted E: ", enemy_array)
	var e1 = enemy_array.get(0)
	var e2 = enemy_array.get(1)
	var e3 = enemy_array.get(2)
	dice_4.dice_result = e1
	dice_5.dice_result = e2
	dice_6.dice_result = e3
	return enemy_array


func _comparing_values_and_scoring():
	var player_1 = player_array.get(0)
	print("p#1 ", player_1)
	var player_2 = player_array.get(1)
	print("p#2 ", player_2)
	var player_3 = player_array.get(2)
	print("p#3 ", player_3)
	var enemy_1 = enemy_array.get(0)
	print("e#1 ", enemy_1)
	var enemy_2 = enemy_array.get(1)
	print("e#2 ", enemy_2)
	var enemy_3 = enemy_array.get(2)
	print("e#3 ", enemy_3)
	var player_total_wins: int = 0
	var enemy_total_wins: int = 0
	if player_1 > enemy_1:
		print("player 1 win")
		player_total_wins += 1
	elif player_1 < enemy_1:
		print("enemy 1 win")
		enemy_total_wins += 1
	elif player_1 == enemy_1:
		print("stalemate")
	else:
		print("wut??? (1)")
	
	if player_2 > enemy_2:
		print("player 2 win")
		player_total_wins += 1
	elif player_2 < enemy_2:
		print("enemy 2 win")
		enemy_total_wins += 1
	elif player_2 == enemy_2:
		print("stalemate")
	else:
		print("wut??? (2)")
	
	if player_3 > enemy_3:
		print("player 3 win")
		player_total_wins += 1
	elif player_3 < enemy_3:
		print("enemy 3 win")
		enemy_total_wins += 1
	elif player_3 == enemy_3:
		print("stalemate")
	else:
		print("wut??? (3)")
	
	print("player wins: ", player_total_wins)
	print("enemy wins: ", enemy_total_wins)
	if player_total_wins > enemy_total_wins:
		_confetti()
	elif enemy_total_wins > player_total_wins:
		camera_effect(3, 10)
	else:
		print("nope")
		pass


func _confetti() -> void:
	confetti.visible = true
	await get_tree().create_timer(1.1).timeout
	confetti.visible = false


# INFO: For convenience made into dedicated function
func camera_effect(shake_duration = null, shake_strength = null) -> void:
	ScreenShaker2D.instance.shake(shake_duration, shake_strength)
