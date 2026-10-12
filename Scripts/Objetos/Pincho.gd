extends Node2D
class_name Pincho

func _on_area_colision_body_entered(body: Node2D) -> void:
	if body is protagonista:
		print("--- 1. PINCHO DETECTÓ ALGO: ", body.name, " ---")
		# 1. Le decimos al personaje cuál fue la causa de su muerte
		if "tipo_causa_muerte" in body:
			body.tipo_causa_muerte = "pincho"
			
		# 2. Activamos la muerte
		ControladorMuerte.a_muerto = true
