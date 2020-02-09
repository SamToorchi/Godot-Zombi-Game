extends "res://scripts/entity.gd"

var movetimer_lenght = 120
var movetimer = 0
const DAMAGE = 1

func _ready():
	$anim.play("default")
	movedir = dir.rand()

func _physics_process(delta):
	movement_loop()
	damage_loop()
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = dir.rand()
		movetimer = movetimer_lenght
