extends KinematicBody2D

export(int) var SPEED = 0

var movedir = dir.center
var spritedir = "down"

var knockdir = Vector2(0,0)
var hitstun = 0
var health = 1
export(String) var TYPE = "ENEMY"

func movement_loop():
	var motion
	if hitstun == 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * SPEED 
	move_and_slide(motion, Vector2(0,0))
	
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
		
func damage_loop():
	# kleine zeitliche Puffer, bis Hitstun wieder auf 0 ist
	if hitstun > 0:
		hitstun -= 1
	for body in $hitbox.get_overlapping_bodies():
		#solange man noch keinen Schlag bekommen hat und die Variablen der Objekte, die "DAMAGE" heißen, existieren und der TYPE ungleich sind (z.B. Player oder Feind)
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			health -= body.get("DAMAGE")
			hitstun = 10
			# man nimmt seine aktuelle Position und subtraiert mit der Position der Body and der Berührungspunkt
			knockdir = transform.origin - body.transform.origin
