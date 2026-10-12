extends Node2D
class_name Disparador

# Arrastra tu escena de Flecha.tscn aquí desde el Inspector
@export var flecha_scene: PackedScene 

# Cadencia de disparo en segundos
@export var tiempo_entre_disparos: float = 2.0 

# Dirección a la que disparará: Vector2.LEFT, RIGHT, UP o DOWN
@export var direccion_disparo: Vector2 = Vector2.LEFT:
	set(val):
		direccion_disparo = val
		ajustar_orientacion_disparador()

@onready var punto_disparo: Marker2D = $PuntoDisparo
@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	ajustar_orientacion_disparador()
	
	# Configurar el Timer
	timer.wait_time = tiempo_entre_disparos
	timer.one_shot = false
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	disparar()

func disparar() -> void:
	if flecha_scene == null:
		return
	
	# Instanciar la flecha
	var nueva_flecha = flecha_scene.instantiate() as Flecha
	
	# Asignamos la posición inicial en el Marker2D (boca)
	nueva_flecha.global_position = punto_disparo.global_position
	
	# Pasamos la dirección elegida a la flecha
	nueva_flecha.direccion = direccion_disparo
	
	# Añadimos la flecha a la escena principal (no como hijo del disparador)
	get_tree().current_scene.add_child(nueva_flecha)

func ajustar_orientacion_disparador() -> void:
	if not is_node_ready() or sprite == null or punto_disparo == null:
		return

	# Asumiendo que tu cabeza de monstruo se dibujó mirando a la IZQUIERDA:
	match direccion_disparo:
		Vector2.RIGHT:
			sprite.flip_h = true
			sprite.rotation = 0
			punto_disparo.position = Vector2(16, 0) # Desplaza el origen a la boca derecha
		Vector2.LEFT:
			sprite.flip_h = false
			sprite.rotation = 0
			punto_disparo.position = Vector2(-16, 0) # Desplaza el origen a la boca izquierda
		Vector2.UP:
			sprite.flip_h = false
			sprite.rotation = deg_to_rad(90)
			punto_disparo.position = Vector2(0, -16) # Desplaza el origen arriba
		Vector2.DOWN:
			sprite.flip_h = false
			sprite.rotation = deg_to_rad(-90)
			punto_disparo.position = Vector2(0, 16) # Desplaza el origen abajo
