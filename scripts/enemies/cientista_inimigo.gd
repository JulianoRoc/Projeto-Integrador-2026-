extends CharacterBody2D

@export var velocidade_patrulha: float = 60.0
@export var velocidade_perseguicao: float = 160.0
@export var tela_game_over: Node = null

@onready var timer_patrulha: Timer = $TimerPatrulha
@onready var campo_de_visao: Area2D = $CampoDeVisao
@onready var area_captura: Area2D = $AreaCaptura
@onready var sprite: Sprite2D = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum Estados { PATRULHA, PERSEGUICAO }
var estado_atual = Estados.PATRULHA

var direcao_aleatoria: float = 0.0
var player_ref: CharacterBody2D = null

func _ready():
	process_mode = Node.PROCESS_MODE_INHERIT
	
	if timer_patrulha:
		timer_patrulha.timeout.connect(_on_timer_patrulha_timeout)
	
	campo_de_visao.body_entered.connect(_on_campo_visao_body_entered)
	campo_de_visao.body_exited.connect(_on_campo_visao_body_exited)
	area_captura.body_entered.connect(_on_area_captura_body_entered)
	
	_on_timer_patrulha_timeout()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	match estado_atual:
		Estados.PATRULHA:
			velocity.x = direcao_aleatoria * velocidade_patrulha
			
			if is_on_wall():
				direcao_aleatoria *= -1
				velocity.x = direcao_aleatoria * velocidade_patrulha
				_atualizar_escala_sprite(direcao_aleatoria)
				if timer_patrulha: 
					timer_patrulha.start() 

		Estados.PERSEGUICAO:
			if player_ref:
				if "esta_escondido" in player_ref and player_ref.esta_escondido:
					perder_player()
				else:
					var direcao_para_player = sign(player_ref.global_position.x - global_position.x)
					
					if is_on_wall() and direcao_para_player == sign(get_wall_normal().x):
						velocity.x = 0
					else:
						velocity.x = direcao_para_player * velocidade_perseguicao
					
					if direcao_para_player != 0:
						_atualizar_escala_sprite(direcao_para_player)
			else:
				estado_atual = Estados.PATRULHA

	move_and_slide()

func _on_timer_patrulha_timeout():
	if estado_atual == Estados.PATRULHA:
		direcao_aleatoria = [ -1.0, 0.0, 1.0 ].pick_random()
		_atualizar_escala_sprite(direcao_aleatoria)

func _atualizar_escala_sprite(dir: float):
	if dir > 0:
		sprite.flip_h = true    
		campo_de_visao.rotation = PI  
		area_captura.rotation = PI
	elif dir < 0:
		sprite.flip_h = false         
		campo_de_visao.rotation = 0
		area_captura.rotation = 0

func _on_campo_visao_body_entered(body):
	if body is CharacterBody2D and body.name.to_lower() == "player":
		if "esta_escondido" in body and not body.esta_escondido:
			player_ref = body
			estado_atual = Estados.PERSEGUICAO
			print("Cientista avistou o macaco!")

func _on_campo_visao_body_exited(body):
	if body == player_ref:
		perder_player()

func perder_player():
	player_ref = null
	estado_atual = Estados.PATRULHA
	print("Cientista perdeu o macaco de vista...")
	_on_timer_patrulha_timeout()

func _on_area_captura_body_entered(body):
	if body is CharacterBody2D and body.name.to_lower() == "player":
		if "esta_escondido" in body and not body.esta_escondido:
			capturar_player(body)

func capturar_player(player: CharacterBody2D):
	print("Game Over!")
	player.pode_se_mover = false
	player.velocity = Vector2.ZERO
	
	if tela_game_over:
		tela_game_over.visible = true
	get_tree().paused = true
