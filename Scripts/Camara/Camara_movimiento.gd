extends Camera2D
class_name CamaraRunner

@export_group("Filtros de Movimiento")
@export var objetivo: Node2D # Arrastra a tu personaje aquí
@export var suavizado_seguimiento: float = 5.0
@export var offset_velocidad_x: float = 40.0 # Adelanta la cámara hacia donde mira el jugador

@export_group("Efecto de Velocidad (Speed Zoom)")
@export var zoom_normal: Vector2 = Vector2(1.0, 1.0)
@export var zoom_correr: Vector2 = Vector2(0.9, 0.9) # Abre el campo visual al correr

# Parámetros para el Screen Shake
var fuerza_shake: float = 0.0
var decaimiento_shake: float = 10.0

func _process(delta: float) -> void:
	if objetivo:
		procesar_seguimiento(delta)
		procesar_zoom(delta)
	
	procesar_shake(delta)

func procesar_seguimiento(delta: float) -> void:
	# Adelanta la cámara según la dirección de movimiento para ver más mapa
	var objetivo_x = objetivo.global_position.x
	if objetivo is CharacterBody2D and objetivo.velocity.x != 0:
		var direccion_x = sign(objetivo.velocity.x)
		objetivo_x += direccion_x * offset_velocidad_x
	
	var pos_destino = Vector2(objetivo_x, objetivo.global_position.y)
	global_position = global_position.lerp(pos_destino, suavizado_seguimiento * delta)

func procesar_zoom(delta: float) -> void:
	if objetivo is CharacterBody2D:
		var esta_corriendo = abs(objetivo.velocity.x) > objetivo.VELOCIDAD_ANDAR
		var zoom_destino = zoom_correr if esta_corriendo else zoom_normal
		zoom = zoom.lerp(zoom_destino, 2.0 * delta)

func aplicar_shake(fuerza: float) -> void:
	fuerza_shake = fuerza

func procesar_shake(delta: float) -> void:
	if fuerza_shake > 0:
		fuerza_shake = lerp(fuerza_shake, 0.0, decaimiento_shake * delta)
		offset = Vector2(
			randf_range(-fuerza_shake, fuerza_shake),
			randf_range(-fuerza_shake, fuerza_shake)
		)
	else:
		offset = Vector2.ZERO
