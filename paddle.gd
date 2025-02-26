extends Area2D 

@export var SPEED = 300.0
@export var up : Key = KEY_W
@export var down : Key = KEY_S

func _process(delta):
	if Input.is_key_pressed(up):
		position.y -= SPEED * delta
	if Input.is_key_pressed(down):
		position.y += SPEED * delta
