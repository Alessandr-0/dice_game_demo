extends Node


@export var dice_1: Control
@export var dice_2: Control
@export var dice_3: Control
@export var dice_4: Control
@export var dice_5: Control
@export var dice_6: Control

@export var confetti: CanvasLayer
@export var player_score_label: Label
@export var enemy_score_label: Label


var dice_can_be_rolled: bool
var player_array: Array[int]
var enemy_array: Array[int]
var my_collected_array: Array
var my_sorted_array: Array
var player_total_score: int = 0
var enemy_total_score: int = 0

func _ready() -> void:
	confetti.visible = false
	dice_can_be_rolled = true


func _on_button_player_pressed() -> void:
	if dice_can_be_rolled:
		dice_can_be_rolled = false
		print("button pressed")
		SignalBus.si_player_button_was_pressed.emit()
		await get_tree().create_timer(0.3).timeout
		SignalBus.si_dice_rolled.emit()
		await get_tree().create_timer(2.0).timeout
		SignalBus.si_dice_picked_up.emit()
		_fill_player_array()
		_fill_enemy_array()
		await get_tree().create_timer(2.0).timeout
		_comparing_values_and_scoring()

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
	var player_2 = player_array.get(1)
	var player_3 = player_array.get(2)
	var enemy_1 = enemy_array.get(0)
	var enemy_2 = enemy_array.get(1)
	var enemy_3 = enemy_array.get(2)
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
		print("WUT??? (1)")
	
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
		SignalBus.si_player_won.emit()
		player_total_score += 1
		player_score_label.text = String.num_int64(player_total_score,10, false)
	elif enemy_total_wins > player_total_wins:
		camera_effect(3, 10)
		SignalBus.si_player_lost.emit()
		enemy_total_score += 1
		enemy_score_label.text = String.num_int64(enemy_total_score,10, false)
	else:
		SignalBus.si_dissapointed.emit()
		camera_effect(1.0,2.0)
		print("nope")
		pass
	dice_can_be_rolled = true


func _confetti() -> void:
	confetti.visible = true
	await get_tree().create_timer(1.1).timeout
	confetti.visible = false


# INFO: For convenience made into dedicated function
func camera_effect(shake_duration = null, shake_strength = null) -> void:
	ScreenShaker2D.instance.shake(shake_duration, shake_strength)
