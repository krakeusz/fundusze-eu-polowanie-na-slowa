extends Node2D

signal quitting(result: String)


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SummaryScreen").visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_world_game_minigame_triggered():
	visible = true


func _on_summary_exit_button_pressed():
	visible = false
	emit_signal("quitting", "CANCEL")


func _on_summary_accepted_button_pressed():
	get_node("SummaryScreen").visible = false
	get_node("DescriptionScreen").visible = true


func _on_description_accepted_button_pressed():
	get_node("DescriptionScreen").visible = false
	get_node("GameScreen").visible = true


func _on_game_screen_exit_game(result):
	get_node("GameScreen").visible = false
	emit_signal("quitting", result)
