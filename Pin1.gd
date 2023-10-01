extends TextureRect

var is_close = false

var animationPlayer: AnimationPlayer

var distantPinResource: Texture2D
@export var closePinResource: Texture2D

var distantScale: Vector2
@export var closeScale = Vector2(1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	distantPinResource = texture
	distantScale = scale
	
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:scale")
	animation.track_insert_key(track_index, 0.0, Vector2(0.3, 0.3))
	animation.track_insert_key(track_index, 1.0, Vector2(1.0, 1.0))
	var lib = AnimationLibrary.new()
	lib.add_animation("zoom_in", animation)
	animationPlayer = AnimationPlayer.new()
	animationPlayer.add_animation_library("", lib)
	add_child(animationPlayer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_world_game_pin_distance_update(pin_name, close):
	if pin_name != name:
		return
	
	if close and not self.is_close:
		print("%s: zoom in" % name)
		#animationPlayer.play("zoom_in")
		texture = closePinResource
		scale = closeScale
	elif not close and self.is_close:
		print("%s: zoom out" % name)
		texture = distantPinResource
		scale = distantScale
		#animationPlayer.play("zoom_in", -1.0, 1.0, true)
	self.is_close = close
