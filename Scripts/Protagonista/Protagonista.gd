extends CharacterBody2D
class_name protagonista

const VELOCIDAD_ANDAR  = 100.0
const VELOCIDAD_CORRER = 300.0
const GRAVEDAD  = 980.0
const FUERZA_SALTO = -400.0
const FUERZA_SALTO_PARED_X = 300.0
const FUERZA_SALTO_PARED_Y = -350.0 

@export var nodo_conteo: ConteoInicio

@onready var state_machine: Node = $FSM
@onready var animaciones: AnimatedSprite2D = $Animaciones
@onready var colision: CollisionShape2D = $Colision
@onready var hurt_box: Area2D = $HurtBox

var se_puede_mover: bool = false
var cooldown_pared: float = 0.0
var ultima_normal_pared: float = 0.0

func _ready() -> void:
	se_puede_mover = false
	velocity = Vector2.ZERO
	ControladorMuerte.a_muerto = false

	# Si asignaste el nodo directamente en el inspector, se conecta aquí
	if nodo_conteo and not nodo_conteo.conteo_finalizado.is_connected(_on_cuenta_atras_terminada):
		nodo_conteo.conteo_finalizado.connect(_on_cuenta_atras_terminada)

func _on_cuenta_atras_terminada() -> void:
	print("--- 3. JUGADOR RECIBIÓ LA LLAMADA ---")
	se_puede_mover = true
	# Transición del estado Bloqueador al estado siguiente
	var estado_bloqueador = $FSM.get_node_or_null("BLOQUEADOR")
	print("--- 4. NODO BLOQUEADOR ENCONTRADO: ", estado_bloqueador, " ---")
	if estado_bloqueador and estado_bloqueador.has_method("terminar_conteo"):
		estado_bloqueador.terminar_conteo()

func _physics_process(delta: float) -> void:
	if cooldown_pared > 0:
		cooldown_pared -= delta

	if is_on_floor():
		cooldown_pared = 0.0

	aplicar_gravedad(delta)
	morir()
	move_and_slide()
	
func aplicar_gravedad(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

func control_movimiento(corriendo: bool) -> void:
	if not se_puede_mover:
		velocity.x = 0
		return
		
	var direccion = Input.get_axis("Izquierda", "Derecha")
	var velocidad_actual = VELOCIDAD_CORRER if corriendo else VELOCIDAD_ANDAR
	
	if direccion != 0:
		velocity.x = direccion * velocidad_actual
		if animaciones:
			animaciones.flip_h = (direccion < 0)
	else:
		velocity.x = 0

func realizar_salto(corriendo: bool) -> void:
	if not se_puede_mover:
		return
		
	velocity.y = FUERZA_SALTO
	var direccion := Input.get_axis("Izquierda", "Derecha")
	
	var debe_correr = corriendo or abs(velocity.x) > VELOCIDAD_ANDAR
	var velocidad_actual = VELOCIDAD_CORRER if debe_correr else VELOCIDAD_ANDAR
	
	if direccion != 0:
		velocity.x = direccion * velocidad_actual

func realizar_salto_pared_por_direccion(dir_pulsada: float) -> void:
	if not se_puede_mover:
		return
		
	var normal_pared = get_wall_normal()
	if normal_pared.x == 0:
		normal_pared.x = ultima_normal_pared

	velocity.x = normal_pared.x * FUERZA_SALTO_PARED_X
	velocity.y = FUERZA_SALTO_PARED_Y
	
	cooldown_pared = 0.25 
	
	if animaciones and normal_pared.x != 0:
		animaciones.flip_h = (normal_pared.x < 0)
		
	var camara = get_viewport().get_camera_2d() as CamaraRunner
	if camara:
		camara.aplicar_shake(1.0)

func morir() -> void:
	if ControladorMuerte.a_muerto:
		ControladorMuerte.a_muerto = false # Consumimos el flag
		print("--- PROTAGONISTA PROCESA LA MUERTE ---")
		
		var estado_muerte = $FSM.get_node_or_null("MUERTE")
		if estado_muerte:
			print("--- CAMBIANDO DIRECTAMENTE A ESTADO MUERTE ---")
			$FSM.cambiar_estado(estado_muerte)
		else:
			print("--- ERROR: NO SE ENCONTRÓ EL NODO 'MUERTE' EN $FSM ---")

# Opcional: Si mantienes la HurtBox (Area2D) para recibir impactos directos de Area2D
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is Flecha:
		ControladorMuerte.a_muerto = true
		area.queue_free()
