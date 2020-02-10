extends Camera2D

export var zoomspeed = 10
export var zoommargin = 0.1

var zoompos = Vector2()
var zoomfactor = 1.0

func _process(delta):
	var pos = get_node("../player").global_position
	var x = floor(pos.x) - 16
	var y = floor(pos.y) - 16
	global_position =  lerp(global_position, Vector2(x,y), 0.1)
	
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)

func _input(event):
	if abs(zoompos.x - get_global_mouse_position().x) > zoommargin:
		zoomfactor = 1.0
	if abs(zoompos.y - get_global_mouse_position().y) > zoommargin:
		zoomfactor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfactor -= 0.05
				zoompos = get_global_mouse_position() 
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfactor += 0.05
				zoompos = get_global_mouse_position() 
