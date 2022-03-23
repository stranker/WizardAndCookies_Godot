extends Node

enum InputType { KEYBOARD, GAMEPAD }
const MAX_KEYBOARD_PLAYERS : int = 2
var keyboard_players : int = 0

# Registers players as a dictionary
var players_input : Dictionary = {}

# Procedural mapping for players with default keys for Player1(key:1) or Player2(key:2)
var player_actions : Dictionary = {
	"ui_accept_":{"key":[KEY_SPACE,KEY_KP_1], "button":JOY_BUTTON_0},
	"ui_select_":{"key":[KEY_SPACE,KEY_KP_1], "button":JOY_BUTTON_0},
	"ui_back_":{"key":[KEY_L,KEY_KP_9], "button":JOY_BUTTON_1},
	"move_left_":{"key":[KEY_A,KEY_LEFT], "button":JOY_BUTTON_14, "axis":[JOY_AXIS_0,-1]},
	"move_right_":{"key":[KEY_D,KEY_RIGHT], "button":JOY_BUTTON_15, "axis":[JOY_AXIS_0,1]},
	"move_up_":{"key":[KEY_W,KEY_UP], "button":JOY_BUTTON_12, "axis":[JOY_AXIS_1,-1]},
	"move_down_":{"key":[KEY_S,KEY_DOWN], "button":JOY_BUTTON_13, "axis":[JOY_AXIS_1,1]},
	"fly_":{"key":[KEY_SHIFT,KEY_KP_2], "button":JOY_BUTTON_4},
	"jump_":{"key":[KEY_SPACE,KEY_KP_1], "button":JOY_BUTTON_0},
	"first_skill_":{"key":[KEY_J,KEY_KP_4], "button":JOY_BUTTON_2},
	"second_skill_":{"key":[KEY_K,KEY_KP_5], "button":JOY_BUTTON_3},
	"third_skill_":{"key":[KEY_L,KEY_KP_6], "button":JOY_BUTTON_1}
}

func get_input_type(event : InputEvent):
	return InputType.KEYBOARD if event is InputEventKey else InputType.GAMEPAD

func is_using_gamepad(player_id : int):
	return players_input[player_id]["input_type"] == InputType.GAMEPAD

func add_player(player_id: int, event : InputEvent):
	if players_input.keys().has(player_id):
		print("InputManager: Already player_id on players_input")
		return
	var input_type = get_input_type(event)
	keyboard_players += 1 if input_type == InputType.KEYBOARD else 0
	var input_data : Dictionary = {"input_type":input_type, "device":event.device}
	players_input[player_id] = input_data
	print("Players Input:" + str(players_input))
	_add_player_actions(player_id, input_type, event.device)
	pass

func _add_player_actions(player_id : int, input_type : int, device : int):
	for action in player_actions.keys():
		var action_name = action + str(player_id)
		InputMap.add_action(action_name)
		if input_type == InputType.KEYBOARD:
			var key_input_event = InputEventKey.new()
			if player_actions[action].has("key") and !player_actions[action]["key"].empty():
				key_input_event.scancode = player_actions[action]["key"][0]
				InputMap.action_add_event(action_name, key_input_event)
				player_actions[action]["key"].remove(0)
		else:
			if player_actions[action].has("button"):
				var joy_input_event = InputEventJoypadButton.new()
				joy_input_event.button_index = player_actions[action]["button"]
				InputMap.action_add_event(action_name, joy_input_event)
			if player_actions[action].has("axis"):
				var joy_motion_input_event = InputEventJoypadMotion.new()
				joy_motion_input_event.axis = player_actions[action]["axis"][0]
				joy_motion_input_event.axis_value = player_actions[action]["axis"][1]
				InputMap.action_add_event(action_name, joy_motion_input_event)
	pass

func _remove_player_actions(player_id : int):
	for action in player_actions.keys():
		var action_name = action + str(player_id)
		InputMap.erase_action(action_name)
	pass

func remove_player(player_id : int):
	if players_input.empty(): return
	for id in players_input.keys():
		if id == player_id:
			if players_input[id]["input_type"] == InputType.KEYBOARD:
				keyboard_players -= 1
			_remove_player_actions(id)
			players_input.erase(id)
	pass

func clear_player_input():
	for id in players_input.keys():
		remove_player(id)
	pass

func has_player(player_id : int, event : InputEvent):
	for id in players_input.keys():
		var input_type = players_input[id]["input_type"]
		if id == player_id and input_type == get_input_type(event):
			return true
	return false

func is_input_of_player(player_id : int, event : InputEvent):
	return players_input[player_id]["input_type"] == get_input_type(event) and players_input[player_id]["device"] == event.device

func can_add_player(player_id : int, event : InputEvent):
	if players_input.keys().has(player_id):
		return false
	var is_keyboard = event.device == 0 and get_input_type(event) == InputType.KEYBOARD
	var is_gamepad = get_input_type(event) == InputType.GAMEPAD
	if is_keyboard and keyboard_players != MAX_KEYBOARD_PLAYERS:
		return true
	elif is_gamepad and !has_input_device(get_input_type(event), event.device):
		return true
	return false

func has_input_device(input_type : int, device : int):
	for id in players_input:
		if players_input[id]["device"] == device and players_input[id]["input_type"] == input_type:
			return true
	return false

func create_placeholder_inputs():
	var key_input = InputEventKey.new()
	var gamepad_input = InputEventJoypadButton.new()
	add_player(1, key_input)
	add_player(2, gamepad_input)
	pass
