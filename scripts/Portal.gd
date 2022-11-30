tool

extends Area2D

export(String, FILE) var caminho_prox_cena = ""
export(Vector2) var player_spawn_location = Vector2.ZERO

func _get_configuration_warning() -> String:
	if caminho_prox_cena == "":
		return "caminho_prox_cena não pode ser vazio"
	else:
		return ""


func _on_Portal_body_entered(body):
	Global.player_posicao_inicial = player_spawn_location
	if (get_tree().change_scene(caminho_prox_cena)) != OK:
		print("não foi possível mudar de cena")
