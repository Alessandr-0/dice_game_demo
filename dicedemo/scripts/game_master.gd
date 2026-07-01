extends Node


@export var dice_1: Control
@export var dice_2: Control
@export var dice_3: Control
@export var dice_4: Control
@export var dice_5: Control
@export var dice_6: Control
@export var background: MeshInstance2D
@export var confetti: CanvasLayer
@export var player_score_label: Label
@export var enemy_score_label: Label
@export var my_sound_delay: float = 0.3
@export var skeleton_arm_2d: Node2D



var dice_can_be_rolled: bool
var background_scale: Vector2
var background_scaling_factor: float = 0.9
var tweeny: Tween
var player_array: Array[int]
var enemy_array: Array[int]
var my_collected_array: Array
var my_sorted_array: Array
var player_total_score: int = 0
var enemy_total_score: int = 0


func _ready() -> void:
	confetti.visible = false
	dice_can_be_rolled = true
	background_scale = background.scale


func _on_button_player_pressed() -> void:
	if dice_can_be_rolled:
		dice_can_be_rolled = false
		if tweeny: tweeny.kill()
		_background_scaling()
		SignalBus.si_player_button_was_pressed.emit()
		await get_tree().create_timer(0.3).timeout
		SignalBus.si_dice_rolled.emit()
		await get_tree().create_timer(2.0).timeout
		_move_arm()
		SignalBus.si_dice_picked_up.emit()
		_fill_player_array()
		_fill_enemy_array()
		await get_tree().create_timer(2.0).timeout
		_comparing_values_and_scoring()


## TESTING: Use keyboard input only for playtesting and debugging
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("test_d"):
		if tweeny: tweeny.kill()
		_move_arm()
	if Input.is_action_just_pressed("test_s"):
		# check if a dialog is already running
		if Dialogic.current_timeline != null:
			return
		if _event is InputEventKey and _event.keycode == KEY_ENTER and _event.pressed:
			Dialogic.start('chapterA')
			get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("test_c"):
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
		dice_4.destroy_dice()
	elif player_1 < enemy_1:
		print("enemy 1 win")
		enemy_total_wins += 1
		dice_1.destroy_dice()
	elif player_1 == enemy_1:
		print("stalemate")
		dice_1.destroy_dice()
		dice_4.destroy_dice()
	else:
		print("WUT??? (round 1)")
	await get_tree().create_timer(my_sound_delay).timeout
	
	if player_2 > enemy_2:
		print("player 2 win")
		player_total_wins += 1
		dice_5.destroy_dice()
	elif player_2 < enemy_2:
		print("enemy 2 win")
		enemy_total_wins += 1
		dice_2.destroy_dice()
	elif player_2 == enemy_2:
		print("stalemate")
		dice_2.destroy_dice()
		dice_5.destroy_dice()
	else:
		print("wut??? (round 2)")
	await get_tree().create_timer(my_sound_delay).timeout
	
	if player_3 > enemy_3:
		print("player 3 win")
		player_total_wins += 1
		dice_6.destroy_dice()
	elif player_3 < enemy_3:
		print("enemy 3 win")
		enemy_total_wins += 1
		dice_3.destroy_dice()
	elif player_3 == enemy_3:
		print("stalemate")
		dice_3.destroy_dice()
		dice_6.destroy_dice()
	else:
		print("wut??? (round 3)")
	await get_tree().create_timer(my_sound_delay).timeout
	
	print("player total wins: ", player_total_wins)
	print("enemy total wins: ", enemy_total_wins)
	if player_total_wins > enemy_total_wins:
		_confetti()
		SignalBus.si_player_won.emit()
		player_total_score += 1
		player_score_label.text = String.num_int64(player_total_score,10, false)
	elif enemy_total_wins > player_total_wins:
		camera_effect(3, 4)
		SignalBus.si_player_lost.emit()
		enemy_total_score += 1
		enemy_score_label.text = String.num_int64(enemy_total_score,10, false)
	else:
		SignalBus.si_dissapointed.emit()
		camera_effect(1.0,2.0)
		print("nope")
		pass
	await get_tree().create_timer(0.3).timeout
	SignalBus.si_dice_reconstruct.emit()
	dice_can_be_rolled = true


func _background_scaling():
	tweeny = create_tween().set_ease(Tween.EASE_OUT)
	tweeny.set_trans(Tween.TRANS_BOUNCE)
	tweeny.tween_property(background, "scale", background_scale * background_scaling_factor, 0.3)
	tweeny.tween_property(background, "scale", background_scale, 0.2)


func _confetti() -> void:
	confetti.visible = true
	await get_tree().create_timer(1.1).timeout
	confetti.visible = false


func _move_arm() -> void:
	#await get_tree().create_timer(0.05).timeout
	tweeny = create_tween().set_ease(Tween.EASE_OUT)
	tweeny.set_trans(Tween.TRANS_CUBIC)
	tweeny.tween_property(skeleton_arm_2d, "position", Vector2(1050.0, 180.0), 0.6)
	tweeny.tween_property(skeleton_arm_2d, "rotation_degrees", -45.0 , 0.5)
	tweeny.tween_property(skeleton_arm_2d, "position", Vector2(2000.0, 175.0), 0.4)
	tweeny.tween_property(skeleton_arm_2d, "rotation", 0.0, 0.1)

func camera_effect(shake_duration = null, shake_strength = null) -> void:
	ScreenShaker2D.instance.shake(shake_duration, shake_strength)
