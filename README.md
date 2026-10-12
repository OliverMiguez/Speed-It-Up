# Speed It Up!

![Godot Engine](https://img.shields.io/badge/Godot-v4.x-blue?style=flat-square&logo=godotengine)
![Language](https://img.shields.io/badge/Language-GDScript-informational?style=flat-square)
![Genre](https://img.shields.io/badge/Genre-Rhythm%20Runner-orange?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**Speed It Up!** es un videojuego de tipo *rhythm runner* basado en mecánicas de 3 colores desarrollado sobre **Godot Engine 4**. El proyecto combina patrones rítmicos acelerados, estética de alto contraste y una banda sonora centrada en el género *Jungle*.

---

## Tabla de Contenidos

- [Sobre el Juego](#sobre-el-juego)
- [Mecánicas Principales](#mecánicas-principales)
- [Controles](#controles)
- [Arquitectura Técnica](#arquitectura-técnica)
- [Instalación y Configuración](#instalación-y-configuración)
- [Licencia](#licencia)

---

## Sobre el Juego

En *Speed It Up!*, el jugador debe reaccionar a cambios de color y obstáculos que aparecen de forma sincronizada con la música. La dificultad escala progresivamente a medida que la velocidad del mapa aumenta, exigiendo máxima precisión y reflejos.

---

## Mecánicas Principales

- **Sistema Tridromático:** Jugabilidad centrada en la alternancia de 3 colores primarios/clave para superar obstáculos y plataformas.
- **Banda Sonora Dinámica:** Pistas rítmicas *Jungle* con lógica de audio adaptativa, incluyendo algoritmos de desvanecimiento (*fade-out*) en transiciones y fin de partida.
- **Dificultad Progresiva:** Incremento gradual de velocidad (*acceleration curve*) a lo largo de la sesión de juego.
- **Legibilidad Visual:** Paletas de color seleccionadas para garantizar un alto contraste en pantalla.

---

## Controles

| Acción | Entrada Principal | Entrada Alternativa |
| :--- | :--- | :--- |
| **Mover a la Izquierda** | `A` | Flecha Izquierda |
| **Mover a la Derecha** | `D` | Flecha Derecha |
| **Saltar** | `Espacio` | Flecha Arriba |
| **Esprintar / Acelerar** | `Shift Izquierdo` | — |

---

## Arquitectura Técnica

- **Motor:** Godot Engine 4.x
- **Lenguaje:** GDScript
- **Renderizado:** Forward+ / Mobile (según optimización de exportación)
- **Plataformas Soportadas:** Windows, Linux, HTML5 (Web)

---

## Instalación y Configuración

### Requisitos Previos

- Tener instalado **Godot Engine 4.x** (disponible en [godotengine.org](https://godotengine.org/)).

### Pasos de Ejecución Local

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/speed-it-up.git
   ```

2. Abrir Godot Engine y seleccionar la opción **Importar**.

3. Seleccionar la ruta del proyecto y abrir el archivo `project.godot`.

4. Ejecutar el proyecto presionando `F5` o el botón **Play** en el editor.

---

## Licencia

Este proyecto se distribuye bajo la licencia **MIT**. Consulta el archivo `LICENSE` para más información.
