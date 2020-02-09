extends KinematicBody2D

export(int) var SPEED = 0

var movedir = dir.center
var spritedir = "down"

func movement_loop():
	var motion = movedir.normalized() * SPEED
	move_and_slide(motion, Vector2(0, 0))
	
func spritedir_loop():
	match movedir:
		dir.left:
			spritedir = "left"
		dir.right:
			spritedir = "right"
		dir.up:
			spritedir = "up"
		dir.down:
			spritedir = "down"

func anim_switch(animation):
	var newanim = str(animation,spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)
