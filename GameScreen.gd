extends Node2D

@export var password = "lepsze zarządzanie zamówieniami"

@export var passwordContainer: GridContainer
@export var inputContainer: GridContainer
@export var charPasswordStyleBox: StyleBox
@export var emptyPasswordStyleBox: StyleBox
@export var passwordLabelSettings: LabelSettings
@export var triesLeft: int
@export var resultLabel: Label
var result: String

signal exit_game(result: String)

func addPasswordCharacter(char: String):
	assert(char.length() <= 1)
	var panel: Node
	if char.is_empty():
		panel = $EmptyPanelBlueprint.duplicate()
	else:
		panel = $CharPanelBlueprint.duplicate()
		panel.get_child(0).text = char
		panel.get_child(0).visible = false
	panel.visible = true
	passwordContainer.add_child(panel)
	
func createPasswordBoard():
	var words = password.split(" ", true)
	
	var maxWordLength = 0
	for word in words:
		maxWordLength = max(maxWordLength, word.length())
	passwordContainer.columns = maxWordLength
	
	for y in words.size():
		var x = 0
		var margin = (maxWordLength - words[y].length()) / 2
		for x2 in range(margin):
			addPasswordCharacter("")
			x += 1
		for char in words[y]:
			addPasswordCharacter(char)
			x += 1
		while x < maxWordLength:
			addPasswordCharacter("")
			x += 1

func createInputBoard():
	var alphabet = "AĄBCĆDEĘFGHIJKLŁMNŃOÓPQRSŚTUVWYZŻŹ"
	for char in alphabet:
		var button = $CharButtonBlueprint.duplicate()
		button.visible = true
		button.text = char
		button.input_pressed.connect(_on_input_pressed)
		inputContainer.add_child(button)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	result = "CANCEL"
	createPasswordBoard()
	createInputBoard()
	updateResultLabel()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func find_labels_with_char(char: String):
	var labels = []
	for panel in passwordContainer.get_children():
		if panel.get_child_count() == 1:
			var label = panel.get_child(0) as Label
			if label.text.to_lower() == char.to_lower():
				labels.append(label)
	return labels

func is_win():
	for panel in passwordContainer.get_children():
		if panel.get_child_count() == 1:
			var label = panel.get_child(0) as Label
			if not label.visible:
				return false
	return true

func updateResultLabel():
	if is_win():
			resultLabel.text = "Brawo!"
	elif triesLeft <= 0:
		resultLabel.text = "Wyczerpano limit prób.\nSpróbuj ponownie za kilka minut!"
	else:
		resultLabel.text = "Pozostało prób: %d" % triesLeft

func disableAllButtons():
	for button in inputContainer.get_children():
		button.disabled = true

func _on_input_pressed(char: String, button: Button):
	button.disabled = true
	var labels = find_labels_with_char(char)
	for label in labels:
		label.visible = true
	if labels.is_empty():
		triesLeft -= 1
		if triesLeft <= 0:
			disableAllButtons()
			result = "LOST"
			$Timer.start()
	if is_win():
		disableAllButtons()
		result = "WIN"
		$Timer.start()
	updateResultLabel()

func _exit():
	emit_signal("exit_game")

func _on_timer_timeout():
	emit_signal("exit_game", result)
