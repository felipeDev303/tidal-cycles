# Sesión 5: Cierre y Exhibición — Algorave de Clase

La Sesión 5 es donde todo lo aprendido se convierte en **performance**. Es el día en que les participantes se sueltan, presentan sus sets en vivo y se descubren parte de una comunidad global de live coders.

> En lugar de introducir conceptos técnicos nuevos, esta sesión propone una dinámica de exhibición y una plantilla de set lista para tocar. La pantalla es parte del show: los espectadores ven el código mientras escuchan.

---

## Dinámica Propuesta

Sugiero dividir la clase en cuatro bloques para mantener la energía y asegurar que todes participen:

### 1. Clínica de Código (primeros 30 minutos)

Antes de empezar la muestra, siempre hay nervios y bugs de última hora.

- Abre el espacio para preguntas: *"¿Por qué este `every 4` no aplica?"*, *"¿Cómo hago que las dos voces se sincronicen?"*.
- Fomenta que los compañeros ayuden a depurar. Mirar el código de otros es la forma más rápida de aprender Tidal.
- Si alguien tiene un patrón que no le gusta, pídele a otra persona que lo *modifique* — eso es esencia de live coding colaborativo.

### 2. Algorave de clase (60 minutos)

Cada participante (o dúo) tiene **5–7 minutos** para tocar en vivo.

- **Regla de oro:** No juzgamos la complejidad técnica, sino la **exploración estética**. Un set minimalista con un solo `chop` modulado puede ser más bello que uno con 12 canales saturados.
- **Pantalla compartida obligatoria:** quien toca proyecta su editor mientras suena. La caligrafía del código es parte de la performance.
- Si te da vergüenza, recuerda lema TOPLAP: *"Show us your screens."*

### 3. Rúbrica de Feedback (charla abierta)

Tras cada set, dos preguntas sencillas:

- **A quien tocó:** ¿Qué cambio en vivo te dio más miedo y cómo salió?
- **Al grupo:** ¿En qué momento se sintió que la pieza despegaba o caía?

Evita el "me gustó / no me gustó". Empuja al grupo a describir **sensaciones** y **decisiones musicales** concretas.

### 4. El Día Después (recursos para seguir)

Tidal tiene una curva infinita y una comunidad muy viva. Comparte esta lista:

| Recurso | Descripción |
|---|---|
| [tidalcycles.org/docs](https://tidalcycles.org/docs/) | Documentación oficial, cheat sheet y video curso de Alex McLean. |
| [club.tidalcycles.org](https://club.tidalcycles.org) | Foro oficial. Lugar ideal para preguntas y compartir patrones. |
| [Discord de Tidal](https://tidalcycles.org/) | Chat en vivo de la comunidad (enlace desde el sitio oficial). |
| [TOPLAP](https://toplap.org) | Organización detrás del live coding global. |
| [Algorave](https://algorave.com) | Calendario de eventos de algorave en todo el mundo. |
| [Estuary](https://estuarium.org) | Plataforma web colaborativa para tocar Tidal a distancia con otros. |
| [Mike Hodnick (Kindohm) en YouTube](https://www.youtube.com/@kindohm) | Tutoriales y sets en vivo en inglés. |
| [Wiki interna del repo](../../../docs/wiki/README.md) | Referencia en español de todos los conceptos del taller. |

---

## Plantilla: Estructura de un Set en Vivo

Entrega esta plantilla en la Sesión 4 o al inicio de la 5. Enseña a organizar el código por bloques lógicos para tocar bajo presión.

```haskell
-- ==========================================
-- TÍTULO DEL SET: [Nombre del set]
-- AUTORE: [Tu nombre]
-- DURACIÓN APROXIMADA: 5-7 min
-- ==========================================


-- ------------------------------------------
-- BLOQUE 1: PREPARATIVOS
-- (Evaluar antes de empezar)
-- ------------------------------------------

setcps 0.55       -- tempo en cycles per second

resetCycles       -- empieza desde cero el contador


-- Definición de panic: emergencia rápida
let panic = do hush
               once $ s "superpanic"


-- ------------------------------------------
-- BLOQUE 2: MATERIALES PREPARADOS
-- (Patrones y helpers reutilizables)
-- ------------------------------------------

let beatA   = sound "bd(3,8) [~ cp]"
    beatB   = sound "[bd*2] cp ~ cp"
    bassA   = note "c2 ~ ~ ef2 ~ g2 ~ bf2" # s "supersaw" # cutoff 800
    chordsA = note "<c'maj e'min g'maj a'min>" # s "superpiano" # legato 0.5
    pad     = chop "<8 16 32>" $ sound "bev*4" # cut 1
    rotate  = slow 4 saw


-- ------------------------------------------
-- BLOQUE 3: INTRO
-- (Empieza con poco material)
-- ------------------------------------------

d1 $ pad # gain 0.7
   # cutoff (range 200 4000 (slow 8 perlin))
   # resonance 0.25


-- ------------------------------------------
-- BLOQUE 4: ENTRADA DE BATERÍA
-- (Aquí "enchufas" el groove)
-- ------------------------------------------

d2 $ jux rev $ beatA # gain 0.9


-- ------------------------------------------
-- BLOQUE 5: BAJO Y ARMONÍA
-- (Cuerpo central del set)
-- ------------------------------------------

d3 $ bassA # gain 0.7

d4 $ every 4 (# speed 2)
   $ chordsA
   # pan rotate
   # gain 0.6


-- ------------------------------------------
-- BLOQUE 6: VARIACIONES EN VIVO
-- (Líneas sueltas para evaluar mientras tocas)
-- ------------------------------------------

-- Cambia la batería a la versión B
d2 $ jux (rev . slow 1.5) $ beatB # gain 0.9

-- Densifica el bajo
d3 $ fast 2 $ bassA # gain 0.75

-- Hi-hats con aleatoriedad
d5 $ sometimes (# speed 2)
   $ degradeBy 0.2
   $ sound "hh*16"
   # pan (slow 8 sine)
   # gain 0.55

-- Llena con percusión euclidiana
d6 $ sound "tabla(5,12)" # n (irand 8) # gain 0.6


-- ------------------------------------------
-- BLOQUE 7: CLÍMAX
-- (Sube tensión: más rápido, más filtros, todo abierto)
-- ------------------------------------------

setcps 0.7

d2 $ fast 2 $ jux rev $ beatB # gain 1
d3 $ fast 2 $ bassA # cutoff 4000 # resonance 0.4
d4 $ chunk 4 (# speed 2) $ chordsA # gain 0.7


-- ------------------------------------------
-- BLOQUE 8: OUTRO Y SALIDA
-- (Baja todo poco a poco)
-- ------------------------------------------

setcps 0.45

d2 $ degradeBy 0.5 $ beatA # gain 0.6
d3 silence
d5 silence
d6 silence

d4 $ chordsA # gain 0.4 # room 0.7 # size 0.8 # dry 0.4

d1 $ pad # gain 0.5


-- ------------------------------------------
-- BLOQUE 9: APAGADO
-- ------------------------------------------

hush          -- detiene todo
-- panic      -- si necesitas urgencia (definido arriba)
```

---

## Consejos para la performance

### Antes del set

- **Practica el set entero al menos una vez** sin público. La improvisación tiene su mejor versión cuando tienes mapa mental de adónde puedes ir.
- **Aumenta el tamaño de letra** del editor: el público (y tú) lo va a agradecer.
- **Prueba el sonido en la sala**. Los `gain`/`shape` que en casa van bien pueden saturar en un PA.

### Durante el set

- **Empieza simple.** Un solo `d1` con un patrón claro. La gente necesita un punto de referencia.
- **No tengas miedo del silencio.** `hush` puntual y volver a entrar es uno de los gestos más potentes de Tidal.
- **Si el código falla, es parte del show.** Lee el error en voz alta si la situación lo permite. Es honesto y enseña.
- **Cambia una cosa cada vez.** Si modificas tres canales a la vez nadie (incluido tú) sabrá qué causó qué.

### Después del set

- **Guarda el archivo `.tidal`.** Cada set es una composición que puedes recuperar y revisar.
- **Comparte tu código.** Postear en el foro o en sccode-equivalentes hace crecer a toda la comunidad.

---

## Reflexión final

> Live coding no es sólo una técnica musical: es una forma de hacer pública la **escritura del pensamiento**. Cada vez que evalúas un bloque y suena algo nuevo, el público te ve **decidir**. El error, la duda, la corrección — todo es parte de la obra.

Si llegaste hasta aquí, ya formas parte del movimiento. Toca en algoraves locales, monta sesiones colaborativas en Estuary, abre una jam con amigues. **El próximo set lo das tú.**

> *"Show us your screens."* — TOPLAP

---

## ¿Y ahora qué?

Sugerencias concretas para seguir creciendo:

1. **Asistir a un Algorave** local o conectarse a uno por streaming.
2. **Crear tu librería personal** de helpers en `BootTidal.hs` (orbits con efectos preparados, snippets favoritos, OSCTargets para conectar con Hydra/Resolume).
3. **Cruzar Tidal con visuales**: Hydra es la pareja perfecta y se controla desde el navegador.
4. **Escribir tus propios `SynthDef` de SuperDirt** (heredando lo aprendido en talleres de SuperCollider).
5. **Compartir un set grabado** en redes con `#livecoding` y `#tidalcycles`.

¡Bienvenidos a la comunidad!
