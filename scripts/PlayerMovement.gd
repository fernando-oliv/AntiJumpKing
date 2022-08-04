extends Node2D

var velocidadeX = 0
var speed = 70
var velocidadeY = 0
var gravity = 1.5
var dashTime = 0
var fallingTime = 0
var falling = true
var dashing = false
var haveDash = true
var isFacingRight = true

func _ready():
	pass # Replace with function body.



func _process(delta):
	pass


func _physics_process(delta):
	
	if (falling) :
		fallingTime += 3*delta
		velocidadeY += gravity/40 * pow(fallingTime, 2)
	else :
		velocidadeX = 0
		velocidadeY = 0
		haveDash = true

	#recarrega a cena apertando ESC
	if(Input.is_action_just_pressed("ui_cancel")) :
		return get_tree().reload_current_scene()

	#faz o personagem andar se não estiver caindo
	if (Input.is_action_pressed("ui_left") && !falling) :
		velocidadeX += -1
	#mesma coisa do if de cima
	if (Input.is_action_pressed("ui_right") && !falling) :
		velocidadeX += 1

	if (isFacingRight && velocidadeX < 0) || (!isFacingRight && velocidadeX > 0):
		FlipPlayer()
	
	#apertou dash
	if (Input.is_action_just_pressed("ui_accept") && haveDash == true):
		haveDash = false
		velocidadeY = 0
		dashing = true
		if (Input.is_action_pressed("ui_left")):
			velocidadeX = -2
		else :
			velocidadeX = 2
		print("apertou")

	#soltou o dash
	if (Input.is_action_just_released("ui_accept") && dashing) :
		dashing = false
		dashTime = 0
		velocidadeX = 0
		if (falling):
			velocidadeY = 0.5
		fallingTime = 0

	#segurou o dash
	if (dashing):
		fallingTime = 0
		dashTime += delta
		if (dashTime < 0.13 * 1.15):
			velocidadeY = 0
			if (velocidadeX >= 0):
				velocidadeX += 0.5
			else :
				velocidadeX += -0.5
		else :
			dashing = false
			velocidadeX = 0

	
	translate(Vector2(velocidadeX * speed * delta, velocidadeY)) 

func _on_area_area_entered(area):
	falling = false
	haveDash = true
	#if area.name.begins_with("paredes"):
	#	colidiu?


func _on_area_area_exited(_area):
	falling = true
	velocidadeY = 0.5

func FlipPlayer():
		isFacingRight = !isFacingRight;
		get_node("sprite").set_flip_h(!isFacingRight)
	
