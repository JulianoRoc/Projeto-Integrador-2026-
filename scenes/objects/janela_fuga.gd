extends Area2D

# No Inspetor, você vai arrastar a cena de conclusão para cá
@export_file("*.tscn") var cena_conclusao: String

var player_ref: CharacterBody2D = null

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D and body.name.to_lower() == "player":
		player_ref = body
		print("O macaco alcançou a janela! Fuga concluída!")
		
		# Trava o movimento do player para ele não continuar andando no fundo
		if "pode_se_mover" in player_ref:
			player_ref.pode_se_mover = false
			player_ref.velocity = Vector2.ZERO
			
		_chamar_conclusao()

func _chamar_conclusao():
	if cena_conclusao != "":
		get_tree().change_scene_to_file(cena_conclusao)
	else:
		print("Erro: Esqueceu de arrastar a cena de conclusão no Inspetor da Janela!")
