# Sesión 3: Sonido, Samples y Efectos

En esta sesión dejamos de mirar al patrón y empezamos a esculpir la **textura sonora**. SuperDirt trae cientos de samples por defecto, decenas de efectos y herramientas potentes de manipulación granular. Vamos a usarlas.

> Recordatorio: SuperCollider corriendo, SuperDirt iniciado. Ten a mano los auriculares — algunos ejercicios de filtros y resonancia pueden volverse fuertes.

---

## Ejercicio 1: La biblioteca por defecto y tus propios samples

SuperDirt incluye una carpeta llamada **Dirt-Samples** con cientos de carpetas, cada una correspondiendo a un nombre que puedes usar con `sound`.

```haskell
-- Algunos clásicos
d1 $ sound "bd sn cp hh"
d1 $ sound "bass arpy moog jvbass"
d1 $ sound "tabla:0 tabla:5 tabla:8 tabla:3"
d1 $ sound "voodoo:1 voodoo:3 birds3:0"
```

> **Para encontrarlos:** abre SuperCollider, menú *File → Open user support directory → downloaded-quarks → Dirt-Samples*. Cada subcarpeta es un `sound`.

Para añadir tus propios samples crea una carpeta nueva (ej. `mis-sonidos/`) con archivos `.wav` numerados (`00bd.wav`, `01sn.wav`, ...) y configúrala en SuperDirt (consulta la guía oficial). El orden alfabético determina el índice.

---

## Ejercicio 2: Volumen, paneo, pitch

Los tres parámetros que cambian la "presencia" de un sonido en la mezcla.

```haskell
-- gain: volumen (escala lineal sugerida 0..1)
d1 $ sound "bd hh sn:1 hh sn:1 hh" # gain "1 0.7 0.5"

-- pan: paneo estéreo (0 izq, 0.5 centro, 1 der)
d1 $ sound "numbers:1 numbers:2 numbers:3 numbers:4"
   # pan "0 0.5 1 0.5"

-- speed: velocidad de reproducción (cambia pitch y duración)
d1 $ sound "jungbass:6" # speed "1 1.5 2 0.5"

-- up: transponer en semitonos (sin alterar tanto la duración)
d1 $ sound "jungbass:6" # up "0 ~ 12 24"

-- note: nombre o semitonos sobre C5 (transposición de samples)
d1 $ sound "bd*4" # note "0 12 -7 -12"
```

> **Concepto clave:** En `speed` el valor `2.0` no sólo *acelera*: también sube una octava (12 semitonos). Es física pura: doblar la velocidad de un audio = doblar la frecuencia.

---

## Ejercicio 3: Filtros (esculpir frecuencias)

Igual que en SuperCollider, los filtros son la herramienta para **quitar lo que sobra**.

```haskell
-- Pasa-bajos (Low Pass): deja pasar graves, corta agudos
d1 $ sound "tabla*4" # n "0 1 2 3" # cutoff 400 # resonance 0.2

-- Pasa-altos (High Pass)
d1 $ sound "tabla*4" # n "0 1 2 3" # hcutoff 600 # hresonance 0.2

-- DJ filter: en un solo parámetro de 0 a 1 (LP debajo de 0.5, HP encima)
d1 $ sound "drum*8" # djf "<0.2 0.4 0.6 0.8>"

-- Filtro vocal: añade resonancia tipo voz
d1 $ sound "drum drum drum drum" # vowel "a o e i"

-- Pausa el efecto vocal con consonantes
d1 $ sound "drum drum drum drum" # vowel "a o p p"
```

> **¡Cuidado!** `resonance` cerca de `1` puede volverse extremadamente ruidoso. Empieza por valores bajos (0.1–0.3).

---

## Ejercicio 4: Distorsión, delay y reverb

```haskell
-- Distorsión con shape (también sube mucho el volumen, compensa con gain)
d1 $ sound "kurt:4 kurt:4" # shape "0 0.78" # gain "0.7"

-- Delay: combinación de delay + delaytime + delayfeedback + lock
d1 $ sound "cp"
   # delay 0.8
   # delaytime (1/6)
   # delayfeedback 0.6
   # lock 1                -- 'lock 1' = el delaytime se mide en CICLOS, no segundos

-- Y con todo patroneado:
d1 $ sound "industrial:3*4"
   # delay         "<0 0.4 0.8>"
   # delaytime     "0.2 0.05"
   # delayfeedback "<0.5 0.9>"
   # lock 1

-- Reverb
d1 $ sound "[~ sn]*2" # dry 0.4 # room 0.6 # size 0.8
```

> **Truco profesional:** Asigna `# orbit 0` a varios canales para que **compartan** la instancia de delay/reverb. Esto une la mezcla y ahorra CPU.

```haskell
d1 $ sound "bd*4"  # orbit 0 # delay 0.5 # delayfeedback 0.6 # delaytime (1/8) # lock 1
d2 $ sound "cp(3,8)" # orbit 0   -- comparte el delay de d1
```

---

## Ejercicio 5: Manipulación de samples largos

Si usas un sample de 4 segundos en un patrón de 8 eventos por ciclo, **se solapan**. SuperDirt no los corta solo. Tienes herramientas para esto:

```haskell
-- Cargar un sample largo para experimentar
d1 $ sound "bev"   -- esto seguirá sonando aunque hagas hush

-- cut N: corta el sample anterior cuando llega otro del mismo grupo N
d1 $ sound "bev" # cut 1

-- legato: duración fija (en fracción del paso)
d1 $ sound "bev ~ bev ~" # legato 1
```

Los **trozados** son donde Tidal brilla más:

```haskell
-- chop: divide el sample en N partes y las toca seguidas
d1 $ chop 32 $ sound "bev"

-- striate: divide y entrelaza los N pedazos de cada sample
d1 $ slow 4 $ striate 4 $ sound "arpy:1 arpy:2 arpy:3 arpy:4"

-- randslice: elige un trozo aleatorio cada ciclo
d1 $ randslice 32 $ sound "bev"

-- loopAt: ajusta el sample completo a N ciclos
d1 $ loopAt 8 $ sound "bev"

-- Combinaciones poderosas
d1 $ loopAt "<8 4 16>" $ chop 64 $ sound "bev*4" # cut 1
d1 $ rev $ loopAt 8 $ chop 128 $ sound "bev"
```

> **Concepto clave:** `chop` toca los pedazos en orden; `striate` los entrelaza entre samples distintos; `randslice` los desordena cada ciclo. Cada uno produce una textura totalmente diferente. **Pruébalos uno tras otro con el mismo sample para escuchar la diferencia.**

---

## Ejercicio 6: Aleatoriedad creativa

Tidal trae un sistema de azar **determinista basado en el tiempo**: el mismo ciclo produce siempre los mismos valores. Improvisas con red de seguridad.

```haskell
-- Generadores
rand          -- Pattern Double entre 0 y 1
irand n       -- Pattern Int entre 0 y n-1
perlin        -- ruido suave (analógico) entre 0 y 1

-- Aplicaciones
d1 $ sound "tink*16" # gain rand
d1 $ sound "arpy(3,8)" # n (irand 16)
d1 $ s "moog*8" # cutoff (range 200 4000 perlin) # resonance 0.3

-- Selección aleatoria de elementos de una lista
d1 $ s "bd*4" # n (choose [0, 3, 5, 7])
d1 $ s "bd*4" # speed (choose [0.5, 1, 2])

-- Eliminar eventos al azar
d1 $ degrade $ sound "tink*16"          -- 50%
d1 $ degradeBy 0.2 $ sound "tink*16"    -- elimina 20%

-- Reordenar
d1 $ shuffle 4  $ s "arpy*4"
d1 $ scramble 4 $ s "arpy*4"

-- Elegir un patrón completo cada ciclo
d1 $ randcat [ sound "bd*4"
             , sound "cp(3,8)"
             , sound "sn:2 ~ sn:2 ~"
             ]
```

> **Idea para una textura ambiental:** combina `perlin` con `range` para que el `cutoff` se mueva orgánicamente entre 200 Hz y 5 kHz, y aplica un poco de `room` 0.5 + `size` 0.8 + `dry` 0.4.

---

## Ejercicio 7: Construyendo un "kit" expresivo

Vamos a ensamblar todo lo aprendido para crear un **patrón único** con vida propia.

```haskell
setcps 0.55

d1 $ jux rev
   $ every 4 (# speed 2)
   $ chop "<8 16 32>"
   $ sound "bev"
   # cut 1
   # gain 0.85
   # cutoff (range 400 4000 (slow 8 sine))
   # resonance 0.25

d2 $ sometimes (# room 0.8 . size 0.7)
   $ sound "bd(3,8) [~ cp]"
   # gain 0.9

d3 $ degradeBy 0.3
   $ n (irand 16)
   $ sound "arpy*8"
   # pan (slow 4 perlin)
   # gain 0.5
```

---

## Reto final de la sesión

Construye un canal `d1` que suene como una **textura granular evolutiva** durante al menos 4 ciclos:

1. Usa un sample largo (`bev`, `breaks125`, o uno propio).
2. Aplícale `chop` o `striate` con un parámetro patroneado (`<8 16 32>` por ejemplo).
3. Que tenga un filtro modulado por una onda lenta (`slow 8 $ sine`).
4. Combínalo con `# cut 1` para que no se solape.
5. Súmale en `d2` un patrón rítmico euclidiano de batería con `# room` para integrarlo.

> **Pregunta para la clase:** ¿En qué se parece y en qué se diferencia esto de la **síntesis granular** que vimos en SuperCollider con `TGrains`? Pista: aquí no controlamos la posición de lectura grano a grano, pero sí podemos modularla con `begin`/`end` (busca la documentación en la wiki).
