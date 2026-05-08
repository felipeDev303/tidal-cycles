# 1. Introducción a Tidal Cycles

**Tidal Cycles** (Tidal) es un entorno de live coding y un lenguaje específico de dominio (DSL) embebido en **Haskell**, orientado a la creación, composición e improvisación en tiempo real de patrones musicales y de control. Fue iniciado por **Alex McLean** y hoy es uno de los lenguajes más usados en la escena de live coding y *algorave*.

## ¿Qué hace Tidal?

Tidal no produce sonido por sí mismo: genera **patrones de mensajes de control** que se envían por **OSC** (Open Sound Control) a un sintetizador externo. La configuración por defecto usa **SuperCollider** con el sintetizador **SuperDirt**, especializado en manipulación de samples.

Esto significa que Tidal puede controlar prácticamente cualquier cosa que entienda OSC o MIDI: synths, DAWs (Ableton, Reaper), motores de visuales (Resolume, VDMX, Unity, openFrameworks, Processing), MadMapper, etc.

## Características distintivas

- **Patrones cíclicos como primitivo central.** El tiempo se mide en *cycles per second* (cps), no en BPM. Un ciclo es un bucle continuo y todos los patrones se pliegan dentro de él.
- **Mini-notación.** Una sintaxis compacta tipo string (`"bd sn cp"`) que permite describir secuencias, polirritmos, ritmos euclidianos, alternancia, repetición y aleatoriedad de forma muy densa.
- **Composición funcional.** Los patrones son funciones; se transforman y combinan con operadores (`$`, `#`, `.`) y funciones de orden superior (`every`, `jux`, `sometimes`, `chunk`...).
- **Patrones de patrones.** Cualquier parámetro (volumen, paneo, filtros, notas) puede a su vez ser un patrón, lo que permite estructuras polirrítmicas y poliméricas con muy poco código.
- **Re-evaluación en caliente.** Cada bloque de código se evalúa al vuelo en GHCi, manteniendo el reloj en sincronía: el código cambia mientras la música sigue sonando.

## Inspiraciones

Según el propio Alex McLean, Tidal fue influido por:

- Las exploraciones de **Bernard Bel** sobre lenguajes de patrones.
- "Manipulation of Musical Patterns" de **Laurie Spiegel**.
- Los **ritmos de tabla indios** y otras tradiciones polirrítmicas.
- El trabajo previo de **Adrian Ward** y la colaboración *slub*.

## ¿Para quién es esto?

- **Músicos** que quieren explorar generación algorítmica y performance en vivo.
- **Programadores** curiosos de la música, que encuentran en Tidal un lenguaje pequeño, expresivo y matemáticamente elegante.
- **Investigadores** del sonido, el ritmo y la performatividad del código.

## Un primer ejemplo

```haskell
d1 $ every 8 (0.25 <~)
   $ sound "bd hh:8*2 bd hh:8"
   # gain "1 1.4 1 1.4"
   # pan  "0.5 0.1 0.5 0.9"
```

Este fragmento envía a la salida `d1` un patrón de bombo y hi-hat, modulado en ganancia y paneo, donde cada 8 ciclos el patrón se desplaza un cuarto hacia atrás. Una sola línea define una textura rítmica completa.

Para detenerlo:

```haskell
hush
```

Continúa en [Live coding: filosofía e historia](02-live-coding.md) o salta a [Instalación](03-instalacion.md).
