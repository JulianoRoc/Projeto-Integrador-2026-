extends CharacterBody2D

const SPEED = 135.0             
const ACCELERATION = 800.0      
const FRICTION = 1200.0         
const AIR_RESISTANCE = 400.0    

const JUMP_VELOCITY = -280.0    
const FALL_GRAVITY_MULTIPLIER = 1.3 

var pode_escalar = false
var escalando = false
const CLIMB_SPEED = 100.0

var pode_pendurar = false
var pendurado = false
var altura_do_cano = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pode_se_mover = true

func _physics_process(delta):
	if not pode_se_mover:
		velocity = Vector2.ZERO 
		return 
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if pode_pendurar and (Input.is_action_pressed("ui_up") or pendurado):
		if not pendurado:
			pendurado = true
			escalando = false
			global_position.y = altura_do_cano + 20 
		
		velocity.y = 0
		
		if direction:
			velocity.x = direction * (SPEED * 0.6) 
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("ui_down"):
			pendurado = false
			
		if Input.is_action_just_pressed("ui_accept"):
			pendurado = false
			velocity.y = JUMP_VELOCITY * 0.7 
			
	elif pode_escalar and (Input.is_action_pressed("ui_up") or escalando):
		escalando = true
		velocity.y = 0
		var climb_dir = Input.get_axis("ui_up", "ui_down")
		velocity.y = climb_dir * CLIMB_SPEED
		if direction:
			velocity.x = direction * (SPEED * 0.8)
		else:
			velocity.x = 0
			
	else:
		if not pode_escalar: escalando = false
		if not pode_pendurar: pendurado = false
		
		if not is_on_floor():
			if velocity.y > 0:
				velocity.y += gravity * FALL_GRAVITY_MULTIPLIER * delta
			else:
				if Input.is_action_just_released("ui_accept") and velocity.y < -100:
					velocity.y = -100
				velocity.y += gravity * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if direction:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
			else:
				velocity.x = move_toward(velocity.x, direction * SPEED, AIR_RESISTANCE * delta)
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * delta)

	move_and_slide()
	
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

var posicao_antes_de_esconder : Vector2 = Vector2.ZERO

var esta_escondido: bool = false 

func entrar_no_esconderijo():
	pode_se_mover = false
	esta_escondido = true
	velocity = Vector2.ZERO
	
	if has_node("CollisionShape2D"):
		get_node("CollisionShape2D").disabled = true
	
	if has_node("000"):
		get_node("000").visible = false
	else:
		self.visible = false 

func sair_do_esconderijo():
	pode_se_mover = true
	esta_escondido = false
	self.visible = true
	
	if has_node("CollisionShape2D"):
		get_node("CollisionShape2D").disabled = false
	
	if has_node("000"):
		get_node("000").visible = true
		
func _process(delta):
	if get_tree().current_scene.has_node("TelaGameOver") and get_tree().current_scene.get_node("TelaGameOver").visible:
		if Input.is_action_just_pressed("reiniciar") or Input.is_key_pressed(KEY_R):
			get_tree().reload_current_scene()
