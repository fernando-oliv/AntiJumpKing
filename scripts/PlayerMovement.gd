extends Node2D

var velocidadeX
var speed = 70
var velocidadeY = 0;


func _ready():
	pass # Replace with function body.



func _process(delta):
	velocidadeX = 0
	if (Input.is_action_pressed("ui_left")) :
		velocidadeX -= 1
	
	if (Input.is_action_pressed("ui_right")) :
		velocidadeX += 1
	
	translate(Vector2(velocidadeX * speed * delta, velocidadeY * delta)) 
	pass
