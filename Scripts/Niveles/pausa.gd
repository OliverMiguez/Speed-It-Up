extends CanvasLayer
class_name pausa

@onready var musica_pausa: AudioStreamPlayer = $MusicaPausa
@onready var pausa_efecto: AudioStreamPlayer = $PausaEfecto
@onready var h_slider: HSlider = $Panel/HSlider
@onready var fun_mode: CheckBox = $Panel/FunMode

func _ready() -> void:
	# El menú empieza oculto
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS 
	
	# Asigna los valores actuales del volumen y del fun mode
	h_slider.value = Configuracion.volumen_general
	fun_mode.button_pressed = Configuracion.fun_mode_activo
	
	# Bucle de seguridad: Fuerza a TODOS los elementos hijos (sliders, botones, paneles) 
	# a estar activos incluso cuando el juego está pausado.
	for hijo in get_children():
		hijo.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		alternar_pausa()

func alternar_pausa() -> void:
	var esta_pausado = get_tree().paused	
	get_tree().paused = not esta_pausado	
	
	visible = not visible
	
	if visible:
		pausa_efecto.play()
		await get_tree().create_timer(0.5).timeout # Espera 0.5 segundos antes de ejecutar la musica
		musica_pausa.play()
	else:
		musica_pausa.stop()

func _on_fun_mode_toggled(activado: bool) -> void:
	Configuracion.fun_mode_activo = activado
	print("--- FUN MODE / EFECTOS VISUALES:", activado, "---")

func _on_h_slider_changed(nuevo_valor: float) -> void:
	Configuracion.volumen_general = nuevo_valor
	var bus_index = AudioServer.get_bus_index("Master")
	if nuevo_valor <= 0.001:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(nuevo_valor))

# El boton back funciona de igual forma que al presionar ESC
func _on_back_game_pressed() -> void:
	alternar_pausa()


func _on_menu_pressed() -> void:
	if get_tree().current_scene.name == "MenuInicio":
		get_tree().quit()
	else:
		alternar_pausa() # Vuelve invisible de nuevo el menu
		get_tree().change_scene_to_file("res://Escenas/Menu/Menu_inicio.tscn")
		
