extends CharacterBody2D

# === CONFIGURAÇÕES DE FÍSICA REALISTA ===
const SPEED = 180.0             # Velocidade máxima um pouco mais humana/animal
const ACCELERATION = 900.0      # Força para arrancar (leva uns frames até atingir o topo)
const FRICTION = 1200.0         # Atrito no chão (faz ele deslizar de leve antes de parar)
const AIR_RESISTANCE = 400.0    # Controle no ar (é mais difícil mudar de direção pulando)

const JUMP_VELOCITY = -380.0    # Pulo inicial firme
const FALL_GRAVITY_MULTIPLIER = 1.6 # O macaco cai mais rápido do que sobe (sensação de peso!)

# Variáveis para o Armário
var pode_escalar = false
var escalando = false
const CLIMB_SPEED = 130.0

# Novas Variáveis para Pendurar no Teto (Luz)
var pode_pendurar = false
var pendurado = false
var altura_do_cano = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pode_se_mover = true

func _physics_process(delta):
	if not pode_se_mover:
		velocity.y += gravity * delta
		move_and_slide()
		return
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# === LÓGICA 1: PENDURADO NO TETO ===
	if pode_pendurar and (Input.is_action_pressed("ui_up") or pendurado):
		if not pendurado:
			pendurado = true
			escalando = false
			global_position.y = altura_do_cano + 20 
		
		velocity.y = 0
		
		if direction:
			velocity.x = direction * (SPEED * 0.6) # Velocidade justa de braço
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("ui_down"):
			pendurado = false
			
		if Input.is_action_just_pressed("ui_accept"):
			pendurado = false
			velocity.y = JUMP_VELOCITY * 0.7 
			
	# === LÓGICA 2: ESCALANDO O ARMÁRIO ===
	elif pode_escalar and (Input.is_action_pressed("ui_up") or escalando):
		escalando = true
		velocity.y = 0
		var climb_dir = Input.get_axis("ui_up", "ui_down")
		velocity.y = climb_dir * CLIMB_SPEED
		if direction:
			velocity.x = direction * (SPEED * 0.8)
		else:
			velocity.x = 0
			
	# === LÓGICA 3: MOVIMENTO NORMAL NO CHÃO / AR ===
	else:
		if not pode_escalar: escalando = false
		if not pode_pendurar: pendurado = false
		
		# GRAVIDADE INTELIGENTE (Cair com peso)
		if not is_on_floor():
			if velocity.y > 0:
				# Se estiver caindo, aplica uma gravidade extra para dar sensação de impacto
				velocity.y += gravity * FALL_GRAVITY_MULTIPLIER * delta
			else:
				# Se o jogador SOLTAR o botão de pulo antes do topo, o pulo é interrompido (pulo curto)
				if Input.is_action_just_released("ui_accept") and velocity.y < -100:
					velocity.y = -100
				velocity.y += gravity * delta

		# PULO (Apenas no chão)
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# ACELERAÇÃO E INÉRCIA HORIZONTAL
		if direction:
			if is_on_floor():
				# No chão ele arranca rápido
				velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
			else:
				# No ar o controle é mais suave (difícil mudar de ideia no meio do pulo)
				velocity.x = move_toward(velocity.x, direction * SPEED, AIR_RESISTANCE * delta)
		else:
			if is_on_floor():
				# Dá aquela "deslizada" de leve bem característica de animais correndo
				velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * delta)

	move_and_slide()
	
	# === MECÂNICA DE EMPURRAR/PUXAR CAIXAS PERFEITA (COM SHIFT) ===
	var empurrando_objeto = false
	
	if Input.is_action_just_released("segurar_objeto"):
		if has_node("JuntaInvisivel"):
			get_node("JuntaInvisivel").queue_free()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var objeto = collision.get_collider()
		
		if objeto is RigidBody2D:
			if Input.is_action_pressed("segurar_objeto"):
				empurrando_objeto = true
				
				var direcao_forca = collision.get_normal() * -1
				var forca_empurrao = direcao_forca * 2500.0
				objeto.apply_central_force(forca_empurrao)
				
				if not has_node("JuntaInvisivel"):
					var junta = PinJoint2D.new()
					junta.name = "JuntaInvisivel"
					junta.node_a = get_path()
					junta.node_b = objeto.get_path()
					junta.global_position = collision.get_position()
					junta.disable_collision = true
					add_child(junta)

	# EFEITO DE PESO AO ARRASTAR
	if empurrando_objeto and direction:
		velocity.x = direction * (SPEED * 0.4)


func _on_sensor_luz_body_entered(body):
	if body == self:
		pode_pendurar = true
		altura_do_cano = %cabo.global_position.y

func _on_sensor_luz_body_exited(body):
	if body == self:
		pode_pendurar = false
		pendurado = false

func _on_sensor_escalada_body_entered(body):
	if body == self:
		pode_escalar = true

func _on_sensor_escalada_body_exited(body):
	if body == self:
		pode_escalar = false
		escalando = false

func _on_documento_area_body_entered(body: Node2D) -> void:
	pass

func _on_documento_area_body_exited(body: Node2D) -> void:
	pass
