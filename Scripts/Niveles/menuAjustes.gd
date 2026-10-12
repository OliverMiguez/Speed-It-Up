extends Control

@export_file("*.tscn") var escena_menu_principal: String = "res://Escenas/MenuPrincipal.tscn"

@onready var slider_volumen: HSlider = $HSlider
@onready var check_fun_mode: CheckBox = $FunMode
@onready var boton_volver: Button = $BotonVolver
@onready var mi_camara: Camera2D = $Camera2D
@onready var mi_canvas: CanvasModulate = $CanvasModulate

func _ready() -> void:
	MusicaMenuV2.registrar_nodos(mi_camara, mi_canvas)
	$camara.play()
	$AnimationPlayer.play("Trans 1")
	# 1. Configurar valores iniciales del Slider de Volumen
	slider_volumen.min_value = 0.0
	slider_volumen.max_value = 1.0
	slider_volumen.step = 0.05
	slider_volumen.value = Configuracion.volumen_general
	
	# 2. Configurar valor inicial del Checkbox
	check_fun_mode.button_pressed = Configuracion.fun_mode_activo
	
	# 3. Conectar señales
	slider_volumen.value_changed.connect(_on_volumen_changed)
	check_fun_mode.toggled.connect(_on_fun_mode_toggled)
	boton_volver.pressed.connect(_on_boton_volver_pressed)

func _on_volumen_changed(nuevo_valor: float) -> void:
	Configuracion.volumen_general = nuevo_valor
	
	# Convertimos el valor lineal (0 a 1) a Decibelios (dB) para el canal Master
	var bus_index = AudioServer.get_bus_index("Master")
	if nuevo_valor <= 0.001:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(nuevo_valor))

func _on_fun_mode_toggled(activado: bool) -> void:
	Configuracion.fun_mode_activo = activado
	print("--- FUN MODE / EFECTOS VISUALES:", activado, "---")

func _on_boton_volver_pressed() -> void:
# Cambia a la ruta guardada en 'escena_menu_principal'
	if escena_menu_principal != "":
		get_tree().change_scene_to_file(escena_menu_principal)
	else:
		print("--- ERROR: No has asignado la escena del menú principal ---")
