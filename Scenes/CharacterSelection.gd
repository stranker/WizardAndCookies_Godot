extends Control

onready var character_panels = [$MC/CharacterPanels/SelectCharacterPanel1, $MC/CharacterPanels/SelectCharacterPanel2]
onready var press_start_anim = $PressStart/StartAnimation
onready var can_take_input : bool = true

var current_players : int = 0
var ready_players : int = 0
var wizards_selected_data : Array = []

func _ready() -> void:
	pass

func _input(event):
	if not event is InputEventJoypadButton and not event is InputEventKey: return
	if !can_take_input: return
	if event.is_action_pressed("ui_select") and !event.is_echo():
		add_player(event)
	if event.is_action_pressed("ui_accept_1") and ready_players >= 2:
		start_game()
	if event.is_action_pressed("ui_cancel") and !event.is_echo() and current_players <= 0:
		go_back()
	pass

func start_game():
	GameManager.set_wizards_data_for_gameplay(wizards_selected_data)
	SceneManager.change_scene(SceneManager.Scenes.LOADING_PLAYER_PRESENTATION)
	pass

func go_back():
	InputManager.clear_player_input()
	SceneManager.change_scene(SceneManager.Scenes.MAIN_MENU)
	pass

func _get_first_empty_panel():
	for character_panel in character_panels:
		if character_panel.is_waiting_for_player():
			return character_panel
	pass

func _has_player(event):
	for character_panel in character_panels:
		if InputManager.has_player(character_panel.player_id, event):
			return true
	return false

func add_player(event : InputEvent) -> void:
	if current_players >= character_panels.size(): return
	var character_panel = _get_first_empty_panel() as SelectCharacterPanel
	if character_panel and !InputManager.can_add_player(character_panel.player_id, event): return
	current_players += 1
	character_panel.set_panel_data(event)
	pass

func remove_player(player_id:int) -> void:
	var character_panel = character_panels[player_id - 1] as SelectCharacterPanel
	character_panel.reset_data()
	yield(get_tree().create_timer(0.5),"timeout")
	current_players -= 1
	pass

func _on_SelectCharacterPanel1_on_wizard_selected(wizard_data):
	add_players_accepted(wizard_data)
	pass


func _on_SelectCharacterPanel2_on_wizard_selected(wizard_data):
	add_players_accepted(wizard_data)
	pass

func add_players_accepted(wizard_data) -> void:
	wizards_selected_data.append(wizard_data)
	ready_players += 1
	if ready_players >= 2:
		can_take_input = false
	update_start_animation(true)
	pass

func remove_wizard(player_id):
	for wizard_data in wizards_selected_data:
		var data = wizard_data as WizardData
		if data.player_id == player_id:
			wizards_selected_data.erase(wizard_data)
	ready_players -= 1
	update_start_animation(false)
	pass

func update_start_animation(player_added):
	if player_added and ready_players >= 2:
		press_start_anim.play("Enter")
	elif !player_added and ready_players == 1:
		press_start_anim.play_backwards("Enter")
	pass

func _on_SelectCharacterPanel1_on_wizard_deselected(player_id):
	remove_wizard(player_id)
	pass # Replace with function body.

func _on_SelectCharacterPanel2_on_wizard_deselected(player_id):
	remove_wizard(player_id)
	pass # Replace with function body.

func _on_SelectCharacterPanel1_on_remove_player(player_id):
	remove_player(player_id)
	pass # Replace with function body.


func _on_SelectCharacterPanel2_on_remove_player(player_id):
	remove_player(player_id)
	pass # Replace with function body.


func _on_StartAnimation_animation_finished(anim_name):
	if anim_name == "Enter":
		can_take_input = true
	pass # Replace with function body.
