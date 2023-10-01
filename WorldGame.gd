extends Node2D

@export var moveAnimation: AnimationPlayer
@export var closeDistance: int

signal pin_distance_update(pin_name: String, is_close: bool)
signal minigame_triggered()

var all_animations: Array[StringName]
var currentAnimation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	instantiate_pins()
	all_animations = moveAnimation.get_animation_library("").get_animation_list()
	

func instantiate_pins():
	for pin in get_node("Map/Pins").get_children():
		pin_distance_update.connect(pin._on_world_game_pin_distance_update)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_pins()
	pass

func print_vector(name, v: Vector2):
	print("%s: (%d, %d)" % [name, v.x, v.y])

func _on_animation_player_animation_finished(anim_name):
	currentAnimation += 1
	if currentAnimation < all_animations.size():
		moveAnimation.play(all_animations[currentAnimation])
	emit_signal("minigame_triggered")

func get_center_point(item: Control):
	var t = item.get_global_transform()
	var origin  = t.get_origin()
	#print_vector("%s origin" % item.name, origin)
	var center_point = t * item.pivot_offset
	#print_vector("%s center_point" % item.name, center_point)
	return center_point

func update_pins():
	var player_point = get_center_point(get_node("Player"))
	for pin in get_node("Map/Pins").get_children():
		var pin2: TextureRect = pin
		var pin_point =  get_center_point(pin2)
		#print("global_origin: %d, %d" % [ global_origin.x, global_origin.y ])
		var distance_to_player = (pin_point - player_point).length()
		#if pin2.name == "Pin2":
			#print("distance to %s: %d" % [pin2.name, distance_to_player])
		var isClose = distance_to_player <= closeDistance
		emit_signal("pin_distance_update", pin2.name, isClose)


func _on_fortune_game_quitting(result: String):
	visible = true
	print_debug("got result: %s" % result)


func _on_start_timer_timeout():
	moveAnimation.play(all_animations[currentAnimation])
