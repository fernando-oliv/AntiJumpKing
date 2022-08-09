extends KinematicBody2D

var velocidade = Vector2.ZERO
var speed = 5
var gravity = 10
var dashTime = 0
var fallingTime = 0
var falling = true
var isFacingRight = true

#bout dash 
var dashDirection = Vector2(1,0)
var haveDash = true
var dashing = false

func _ready():
	pass



func _process(delta):
	pass
	

#faz o personagem andar se não estiver caindo
func get_input():
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	
	if (right && !falling):
		velocidade.x += speed
	if (left && !falling):
		velocidade.x -= speed
		
# funcao de dash do player 
func dash():
	if is_on_floor():
		haveDash = true
		
	# define a direcao 
	if Input.is_action_pressed("ui_right"):
		dashDirection = Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		dashDirection = Vector2(-1,0)
		
	if Input.is_action_just_pressed("ui_accept") and haveDash:
		velocidade = dashDirection.normalized() * 100
		haveDash = false 
		dashing = true 
	"""
	se o individuo der dash em uma ponta, ou seja, no chao em direcao ao ar, 
	é possivel dar 2 dashs, pois ele reseta uma vez que ele ainda nao estava no ar
	"""

func _physics_process(delta):
	"""
	lentamente faz o personagem retornar a velocidade x = 0
	pode ser usado para gelo ou só para ficar mais condizente com a realidade
	"""
	velocidade.x = lerp(velocidade.x, 0, 0.05)

	
	velocidade.y += gravity
	
	# movimentacao
	get_input()
	if is_on_floor():
		#print("I collided")
		falling = false
	else:
		falling = true
	velocidade = move_and_slide(velocidade, Vector2(0, -1))
	
	#recarrega a cena apertando ESC
	if(Input.is_action_just_pressed("ui_cancel")) :
		return get_tree().reload_current_scene()

	# para onde o player olha ( depende da velocidade)
	if (isFacingRight && velocidade.x < 0) || (!isFacingRight && velocidade.x > 0):
		FlipPlayer()
	
	#apertou dash
	dash()

	#soltou o dash
	if (Input.is_action_just_released("ui_accept") && dashing) :
		dashing = false
		dashTime = 0
		velocidade.x = 0
		fallingTime = 0

	#segurou o dash
	if (dashing):
		fallingTime = 0
		dashTime += delta
		if (dashTime < 0.13 * 1.15):
			velocidade.y = 0
			if (velocidade.x >= 0):
				velocidade.x += 50
			else :
				velocidade.x += -50
		else :
			dashing = false
			velocidade.x = 0
	
	

func FlipPlayer():
		isFacingRight = !isFacingRight;
		get_node("sprite").set_flip_h(!isFacingRight)
	
