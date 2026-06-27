extends Node

@export var button_presses: AudioStreamPlayer2D
@export var dice_shaking: AudioStreamPlayer2D
@export var dice_rolling: AudioStreamPlayer2D
@export var die_rolling: AudioStreamPlayer2D
@export var dice_pick_up: AudioStreamPlayer2D
@export var dissapointed: AudioStreamPlayer2D
@export var explosions: AudioStreamPlayer2D
@export var exclamation: AudioStreamPlayer2D
@export var enemy: AudioStreamPlayer2D
@export var minimize: AudioStreamPlayer
@export var swoosh: AudioStreamPlayer2D


func _ready() -> void:
	SignalBus.connect("si_any_button_was_pressed", _button_pressed)
	SignalBus.connect("si_game_quit", _minimize)
	SignalBus.connect("si_dice_shaked", _dice_shaker)
	SignalBus.connect("si_dice_rolled", _dice_roller)
	SignalBus.connect("si_die_rolled", _die_roller)
	SignalBus.connect("si_dice_picked_up", _dice_picking_up)
	SignalBus.connect("si_dissapointed", _dissapointed)
	SignalBus.connect("si_dice_destroyed", _dice_destroyed)
	SignalBus.connect("si_player_won", _player_won)
	SignalBus.connect("si_player_lost", _player_lost)


## TESTING: Use keyboard input only for playtesting and debugging
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("test_01"):
		_dice_shaker()
	if Input.is_action_just_pressed("test_02"):
		_dice_roller()
	if Input.is_action_just_pressed("test_03"):
		_die_roller()
	if Input.is_action_just_pressed("test_04"):
		_dice_picking_up()


func _button_pressed() -> void:
	if not button_presses.playing:
		button_presses.play()

func _dice_shaker() -> void:
	if not dice_shaking.playing:
		dice_shaking.play()

func _dice_roller() -> void:
	if not dice_rolling.playing:
		await get_tree().create_timer(0.3).timeout
		dice_rolling.play()

func _die_roller() -> void:
	if not die_rolling.playing:
		die_rolling.play()

func _dice_picking_up() -> void:
	if not dice_pick_up.playing:
		dice_pick_up.play()

func _dissapointed() -> void:
	if not dissapointed.playing:
		dissapointed.play()

func _dice_destroyed() -> void:
	if not explosions.playing:
		explosions.play()

func _player_won() -> void:
	if not exclamation.playing:
		exclamation.play()

func _player_lost() -> void:
	if not enemy.playing:
		enemy.play()

func _minimize() -> void:
	if not minimize.playing:
		minimize.play()
