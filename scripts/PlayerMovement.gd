extends KinematicBody2D

var velocidade = Vector2.ZERO
var speed = 5
var gravity = 10
var fallingTime = 0
var falling = true
var isFacingRight = true
var vento = 0

#bout dash 
var dashDirection = Vector2(1,0)
var dashTime = 0 
var haveDash = true
var dashing = false
var dashSpeed = 50

var velocidadeAnterior = velocidade

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
		
	if Input.is_action_just_pressed("Dash") and haveDash:
		velocidade = dashDirection.normalized() * 100
		haveDash = false 
		dashing = true 
	"""
	se o individuo der dash em uma ponta, ou seja, no chao em direcao ao ar, 
	é possivel dar 2 dashs, pois ele reseta uma vez que ele ainda nao estava no ar
	"""

func _physics_process(delta):
	
	"""bounce"""
	var velocidadeAnterior = Vector2(dashSpeed,0)
	if velocidade.x != 0:
		velocidadeAnterior = velocidade.x 
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider is TileMap and not is_on_floor():
				velocidade.x = collision.normal.x*abs(velocidadeAnterior)*0.6
				dashing = true 

				
	"""
	lentamente faz o personagem retornar a velocidade x = 0
	pode ser usado para gelo ou só para ficar mais condizente com a realidade
	"""
	if(!falling):
		velocidade.x = lerp(velocidade.x, 0, 0.05)

	
	
	# movimentacao
	get_input()
	if is_on_floor():
		#print("I collided")
		falling = false
		fallingTime = 0
		velocidade.y = 0
	else:
		falling = true
		fallingTime += delta
		
		#aplica o vento até um limite de 20
		if abs(velocidade.x) < 20:
			velocidade.x += vento
	
	velocidade.y += gravity * fallingTime
	
	#apertou dash
	dash()

	#soltou o dash
	if (Input.is_action_just_released("Dash") && dashing) :
		dashing = false
		dashTime = 0
		velocidade.x = 0
		fallingTime = 0

	#segurou o dash
	if (dashing):
		fallingTime = 0
		if (dashTime < 0.13 * 1.15):
			dashTime += delta
			velocidade.y = 0
			if (velocidade.x >= 0):
				velocidade.x += dashSpeed
			elif (velocidade.x <= 0) :
				velocidade.x += -dashSpeed
		else :
			dashTime = 0
			dashing = false
			velocidade.x = 0
	if(!falling and Input.is_action_just_pressed("Jump")):
		velocidade.y = -75
	

	velocidade = move_and_slide(velocidade, Vector2.UP)
	#velocidade = move_and_slide(velocidade, Vector2(0,1))
	#recarrega a cena apertando ESC
	if(Input.is_action_just_pressed("ui_cancel")) :
		return get_tree().reload_current_scene()

	# para onde o player olha ( depende da velocidade)
	if (isFacingRight && velocidade.x < 0) || (!isFacingRight && velocidade.x > 0):
		FlipPlayer()
	


func FlipPlayer():
		isFacingRight = !isFacingRight;
		get_node("sprite").set_flip_h(!isFacingRight)
	


#seta o vento quando entra em uma area que começa com o nome VentoDir ou VentoEsq
func _on_Area2D_area_entered(area):
	if area.get_parent().name.begins_with("VentoDir"):
		vento = 5
	if area.get_parent().name.begins_with("VentoEsq"):
		vento = -5

#retorna o vento para 0 ao deixar a área
func _on_Area2D_area_exited(area):
	if area.get_parent().name.begins_with("Vento"):
		vento = 0
