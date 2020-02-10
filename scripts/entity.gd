extends KinematicBody2D

const MAXHEALTH = 2
var health = MAXHEALTH

export(int) var SPEED = 0

var movedir = dir.center
var spritedir = "down"

var knockdir = Vector2(0,0)
var hitstun = 0
export(String) var TYPE = "ENEMY"

var texture_default = null
var texture_hurt = null

func _ready():
	texture_default = $Sprite.texture
	texture_hurt = load($Sprite.texture.get_path().replace(".png", "_hurt.png"))

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
		$Sprite.texture = texture_hurt
	else: 
		$Sprite.texture = texture_default
		if TYPE == "ENEMY" and health <= 0:
			#Animation laden und inizialisieren
			var death_animation = preload("res://scene/enemy_death.tscn").instance()
			#Animation in der Szene einbinden
			get_parent().add_child(death_animation)
			#Position der Animation festlegen
			death_animation.global_transform = global_transform
			queue_free()
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		#solange man noch keinen Schlag bekommen hat und die Variablen der Objekte, die "DAMAGE" heißen, existieren und der TYPE ungleich sind (z.B. Player oder Feind)
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			#health wird um 1 verringert
			health -= body.get("DAMAGE")
			hitstun = 10
			# man nimmt seine aktuelle Position und subtraiert mit der Position der Body and der Berührungspunkt
			knockdir = global_transform.origin - body.global_transform.origin

func use_item(item):
	var newitem = item.instance()
	newitem.add_to_group(str(newitem.get_name(), self))
	add_child(newitem)
	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
		newitem.queue_free()
	
