extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var idle_state: State
@export var caminar_state: State

func on_enter():
	print("BLOQUEADOR ENTRADO")
	if father:
		father.velocity = Vector2.ZERO
		father.se_puede_mover = false
	
	if animation_player:
		animation_player.play("IDLE")

func state_process(delta: float) -> void:
	if father:
		father.velocity.x = 0
		father.aplicar_gravedad(delta)

func terminar_conteo() -> void:
	print("SALIENDO DE BLOQUEADOR")
	if father:
		father.se_puede_mover = true
	
	var direccion := Input.get_axis("Izquierda", "Derecha")
	if direccion != 0:
		next_state = caminar_state
	else:
		next_state = idle_state

func on_exit():
	pass
