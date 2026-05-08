# Consejos Fundamentales de Producción de Dub Techno

## 1. Enfocarse en la Textura y la Atmósfera

- El dub techno se trata de la textura y el ambiente (the real vibecoding?).
- La clave de este género es su sentido de atmósfera, además de los acordes con grandes cantidades de reverberación y delay.
- Se trata de sutileza y textura.
- Es crucial la experimentación.
- Intenta incluir diferentes capas de textura/ruido y capas de procesamiento paralelo.

## 2. Inspiración y Referencias

- Escucha dub. Escucha lo que inspiró las pistas que tanto te gustan y usa esa chispa para alimentar tu propia creatividad.
- Escucha ambient, dub, new age, grabaciones de campo (field recordings), etc., para empaparte de texturas y movimientos sutiles.
- Vuelve a las raíces adecuadas del sonido y escucha el dub reggae auténtico, especialmente a pioneros como King Tubby y Lee Perry.
- Escucha a Basic Channel.
- Tómate tiempo para escuchar los clásicos del género.
- Utiliza una pista de dub techno que te guste como referencia. Obsérvala para ver cómo está arreglada y escucha atentamente cómo los diferentes elementos van y vienen.

## 3. Técnicas de Mezcla y Efectos (El Componente "Dub")

- Aprende sobre las técnicas de mezcla de dub.
- Gran parte del dub techno se basa en cambios en la mezcla (filtros, delays y reverberaciones) en lugar de cambios melódicos.
- Utiliza reverberación y delay en grandes cantidades.
- Utiliza mucho reverb y delay en paralelo.
- Aplica un dub delay a las notas típicas de 8ª y 16ª. Al final, no necesitarás tantas notas.
- Utiliza diferentes delays en secuencia o en paralelo, y modula y automatiza sus parámetros.
- Para evitar sonar aburrido, utiliza LFOs para ajustar filtros, ecualizadores, el feedback del delay y otros parámetros, de modo que el sonido esté siempre evolucionando sutilmente.
- Crea "accidentes felices": Sé atrevido con el delay o la reverberación y remuestrea el resultado. Luego puedes invertirlo, subir o bajar el tono y reorganizar el orden de los golpes.
- Si no usas hardware, una técnica divertida para los pads es usar la señal húmeda (wet) de tu reverberación/delay, grabar el audio y manipularlo (estirando o invirtiendo el audio).
- Experimenta con cualquier tipo de tape delay que puedas modular.

## 4. Sonido y Procesamiento

- Si trabajas "in the box" (con software), intenta emular hardware antiguo usando emulaciones de cinta, saturación o distorsión.
- Usa convolución (como MConvolution) no solo para reverberaciones, sino también para agregar texturas a acordes o baterías y que suenen menos digitales.
- Considera plugins específicos como Modnetic, o plugins útiles para la producción de dub como los de AudioDamage, AudioThing y Nembrini.

## 5. Elementos Melódicos

- Utiliza una gran influencia del jazz en las progresiones de acordes.
- Busca progresiones de acordes usando acordes menores de 7ª y 9ª.
- Usa acordes en abundancia, específicamente un acorde menor.

## 6. Percusión y Ritmo

- Escucha las líneas de bajo en las pistas de dub-reggae.
- Utiliza un kit 808.
- Configura el kit de batería de modo que ningún sonido sea dominante.
- El kick (bombo) debe estar mayormente filtrado hacia abajo, de modo que solo pasen las frecuencias de bajos.

## 7. Flujo de Trabajo y Experimentación

- Evita el error de intentar hacer dub techno de la misma manera que harías house o techno de 16 compases (dibujando automatizaciones). Esto resulta en música plana y sin vida.
- Configura tu DAW con efectos en los returns que se retroalimenten entre sí.
- Toma 4-6 loops y simplemente jammea con ellos sobre la marcha. Esta es la esencia de la música dub.
- Graba tus propios sonidos (el sonido de la lluvia, una tormenta, la ciudad de noche o el bosque al mediodía).
- Añade grabaciones de campo (field recordings) para mejorar el ambiente.
- Añade silbido de fondo (background hiss).
- Experimenta con el diseño de sonido, el timbre y los ritmos. Si bien los consejos técnicos son útiles, la magia ocurre cuando puedes sentir algo y hacer que otros lo sientan también.

## 8. Aprendizaje y Referencia (Profundización)

- Si usas una pista de referencia, intenta recrear cada elemento (batería, bajo, partes melódicas, extras) en diferentes pistas, consultando constantemente la canción original. Esto sirve para aprender cómo crear cada elemento por separado y construir una base para componer tus propias pistas.

## Implementación en TidalCycles

### Conceptos Clave del Dub Techno en TidalCycles

#### Evolución Continua (Anti-Loop)

En TidalCycles, esto se logra manipulando patrones de forma dinámica, alterando ritmos, efectos y parámetros en tiempo real o de forma algorítmica. Usa funciones como `every`, `once`, `lag`, `slow`, `orbit`, y `run` para crear movimiento.

#### Texturas y Capas

Construye atmósferas con múltiples "canales" (orbits) y capas de sonido. Usa `dnoisy`, `pinkNoise`, `sustain` con samples largos, y aplica efectos en paralelo.

#### Delays y Reverbs Característicos

TidalCycles tiene potentes funciones de efectos (`effect`, `delay`, `reverb`). La clave está en modular sus parámetros (`delaytime`, `feedback`, `room`, `size`) con patrones evolutivos o `lag`.

#### Acordes Jazzy

TidalCycles maneja acordes y escalas de forma nativa (`scale`, `chord`, `spread`). Usa `m7`, `m9`, `maj7`, `sus4`, `add9` y aplica `sustain` largo.

#### Mezcla No-Dominante

Controla el volumen (`gain`) y el paneo (`pan`) de cada patrón individualmente. Usa `fadeIn` / `fadeOut` para transiciones suaves.

#### Filtrado "Underwater"

Usa `lpf` y `hpf` (Low Pass Filter / High Pass Filter) y modula su frecuencia (`cutoff`). La modulación con `slow`, `lag`, o incluso otros patrones es clave.

#### "Accidentes Felices"

TidalCycles brilla en esto. Usa `always`, `sometimes`, `once`, `irand`, `rand` para introducir variaciones inesperadas y eventos aleatorios.

### Elementos Esenciales y su Implementación

#### Configuración General

- **Tempo (BPM)**: Establece un tempo típico de dub techno (el tempo se suele configurar en SuperCollider, pero puedes pensar en la "unidad de tiempo" en TidalCycles). Por ejemplo, si tu unidad es la negra, 130 BPM es un buen punto de partida.

#### Batería y Percusión

**Kick Profundo:**

```haskell
d1 $ s "bd_boom" # lpf (slow 8 $ range 80 120 $ sine) # cutoff 120 # sustain 0.1 # gain 0.9 # room 0.1 # orbit 1
```

**Hi-Hats a Contratiempo con Variación:**

```haskell
d2 $ s "hh_closed" # struct "~ x ~ x ~ x ~ [x ~]" # delta (slow 7 $ range 0.95 1.05) # pan (slow 7 $ range (-0.3) 0.3) # cutoff 2000 # gain 0.4 # delay 0.125 # delayfeedback 0.3 # orbit 2
```

**Percusión Adicional (Shakers, Rims):**

```haskell
d3 $ s "shaker" # struct "~ ~ x ~" # gain 0.2 # pan (-0.4) # room 0.3 # delta (slow 1.1) # orbit 3
d4 $ s "rim" # struct "~ ~ ~ x" # gain 0.25 # pan 0.4 # orbit 4
```

#### Bajo

**Bajo Profundo con Movimiento:**

```haskell
d5 $ note "eb1 eb1 gb1 ab1" # sound "saw" # cutoff (slow 16 $ range 200 600 $ perlin) # resonance 0.2 # attack 0.01 # decay 0.2 # sustain 0.7 # release 0.5 # gain 0.6 # orbit 5
```

#### Armonía y Melodía

**Acordes Atmosféricos (Jazz-influenced):**

```haskell
d6 $ chord "Ebm9 Bbm7 Abmaj7 Gbmaj7" # spread 5 # scale "minor" # sound "supersquare" # sustain 0.5 # release 4 # cutoff 800 # gain 0.3 # room 0.7 # size 0.9 # delay 0.5 # delayfeedback 0.6 # pan (slow 32 $ range (-0.5) 0.5 $ sine) # orbit 6
```

**Elemento Melódico Ocasional:**

```haskell
d7 $ note "eb4 bb4 gb4 ab4" # slow 4 # sound "glockenspiel" # struct "x ~ ~ ~ ~ ~ ~ ~" # slow 2 # sometimes (\n -> n "+ n" # gain 0.3) # cutoff 3000 # room 0.6 # delay 0.333 # delayfeedback 0.5 # gain 0.25 # pan 0.3 # orbit 7
```

#### Texturas y Efectos

**Texturas Ambientales:**

```haskell
d8 $ pinkNoise # lpf (slow 64 $ range 300 1000 $ perlin) # hpf 100 # gain 0.05 # pan (irand (-1) 1) # room 0.9 # size 0.95 # sustain 16 # orbit 8
```

**Dub Delays y Efectos:**

```haskell
d9 $ (s "bd_boom" # gain 0.7) # delay 0.75 # delayfeedback (slow 16 $ range 0.25 0.75 $ perlin) # lpf (slow 8 $ range 500 2000 $ sine) # gain 0.2 # orbit 9
```

### Composición Final - Ejemplo Completo

```haskell
-- Dub Techno Completo en TidalCycles
d1 $ s "bd_boom" # lpf (slow 8 $ range 80 120 $ sine) # sustain 0.1 # gain 0.9 # room 0.1 # orbit 1
d2 $ s "hh_closed" # struct "~ x ~ x ~ x ~ [x ~]" # delta (slow 7 $ range 0.95 1.05) # pan (slow 7 $ range (-0.3) 0.3 $ sine) # cutoff 2000 # gain 0.4 # delay 0.125 # delayfeedback 0.3 # orbit 2
d5 $ note "eb1 eb1 gb1 ab1" # sound "saw" # cutoff (slow 16 $ range 200 600 $ perlin) # resonance 0.2 # attack 0.01 # decay 0.2 # sustain 0.7 # release 0.5 # gain 0.6 # orbit 5
d6 $ chord "Ebm9 Bbm7 Abmaj7 Gbmaj7" # spread 5 # scale "minor" # sound "supersquare" # sustain 0.5 # release 4 # cutoff 800 # gain 0.3 # room 0.7 # size 0.9 # delay 0.5 # delayfeedback 0.6 # pan (slow 32 $ range (-0.5) 0.5 $ sine) # orbit 6
d7 $ note "eb4 bb4 gb4 ab4" # slow 4 # sound "glockenspiel" # struct "x ~ ~ ~ ~ ~ ~ ~" # slow 2 # sometimes (\n -> n "+ n" # gain 0.3) # cutoff 3000 # room 0.6 # delay 0.333 # delayfeedback 0.5 # gain 0.25 # pan 0.3 # orbit 7
d8 $ pinkNoise # lpf (slow 64 $ range 300 1000 $ perlin) # hpf 100 # gain 0.05 # pan (irand (-1) 1) # room 0.9 # size 0.95 # sustain 16 # orbit 8
```

### Técnicas Avanzadas y Experimentación

#### Automatización de Parámetros con Patrones Evolutivos

- Usa `lag`, `slow`, `orbit`, `every`, `once` para animar efectos
- `lag` suaviza los cambios de un parámetro
- `slow 8` hace que un patrón se repita cada 8 ciclos de tiempo
- `every 4` ejecuta algo cada 4 ciclos

#### Probabilidades y Variación Continua

- `always`: Ejecuta siempre
- `sometimes`: Ejecuta aprox. el 50% del tiempo
- `often`: Ejecuta aprox. el 75% del tiempo
- `rarely`: Ejecuta aprox. el 25% del tiempo
- `once`: Ejecuta una vez al iniciar el patrón
- `irand`: Número entero aleatorio
- `rand`: Número flotante aleatorio
- `when (> 0.5)`: Ejecuta condicionalmente

#### Estructuras Rítmicas Evolutivas

- `struct` con patrones complejos
- `euclid` para generar ritmos euclidianos (ej. `euclid 3 8` para 3 notas en 8 pasos)
- `mask`: Aplica un patrón de máscara a otro (ej. `s "bd" # mask "10100100"`)

#### Modulación Cruzada (Cross-Modulation)

- Usa un patrón para modular otro
- `xmod` es la función principal para esto en versiones más recientes
- Ejemplo: `orbit 1 $ s "bd" # gain (orbit 2 $ saw)` -- El volumen del kick es controlado por un patrón de sierra en orbit 2

#### Técnica de "Accidentes Felices"

- Combina `irand`, `rand`, `sometimes`, `rarely` en parámetros clave de efectos (feedback, tiempo de delay, cutoff)

#### Reverb y Delay en Cadena

- TidalCycles permite encadenar efectos de forma explícita
- `d1 $ s "tabla" # effect (reverbScal 0.5 0.8) # effect (delay 0.5 0.75) # effect (reverbScal 0.3 0.6)`
- (Nota: la sintaxis de `effect` puede variar ligeramente según la versión de TidalCycles)

#### Emulación de Hardware Vintage y Texturas

- Usa samples degradados, `degrade` o `bitcrusher`
- Busca librerías de samples de cinta o hardware vintage

### Consejos de Producción y Flujo de Trabajo en TidalCycles

- **Comienza Simple**: Empieza con un kick y bajo, luego añade percusión y texturas
- **Live Coding**: La esencia de TidalCycles. Modifica patrones mientras suenan, cambia parámetros de efectos, introduce nuevas ideas
- **Usa `orbit`s**: Asigna cada elemento principal a un `orbit` (canal de sonido) diferente para una mejor organización
- **Graba y Remuestra**: Puedes grabar la salida de TidalCycles a archivos de audio y luego cargarlos como samples en TidalCycles para mayor manipulación
- **Escucha Inspiración**: Dub Reggae / Dub Techno Clásicos: King Tubby, Lee Perry, Basic Channel. Analiza la espacialidad, los "gaps" y la evolución
- **Técnicas de Mezcla Dub**: Usa el concepto de "esculpir el sonido" con filtros y efectos de forma muy activa
- **No "Mapees" todo estáticamente**: La potencia de TidalCycles está en la manipulación de patrones y la improvisación algorítmica. Deja que las "reglas" de tu código generen la complejidad
- **Experimenta con Sound Design**: Crea tus propios sonidos usando osciladores (`sine`, `saw`, `square`, `pluck`) y `xfade` entre ellos o con samples
- **Patrones de Patrones**: Crea patrones que generen otros patrones (ej. un patrón que decide qué `d` se activa o qué sample se usa)

### Procesamiento Master

TidalCycles permite controlar parámetros globales. Para compresión y limiting, a menudo se hace en el entorno de SuperCollider o con un DAW externo. En TidalCycles, puedes controlar el volumen general (`master` o `global` en algunas versiones).

```haskell
mastereq "lowpass 80" -- Ejemplo de EQ global
```

## Elementos Sónicos Característicos del Dub Techno

### Filosofía General: Textura, Evolución y Espacio

El sonido característico del Dub Techno se define por una combinación específica de elementos sónicos y técnicas de mezcla que enfatizan **textura**, **evolución sutil** y **espacio**. No se trata solo de la selección de sonidos, sino de cómo estos interactúan a través de efectos y modulaciones.

### 1. Ritmo y Percusión No-Dominante

#### Kick Profundo (80-120 Hz)

El bombo es fundamental y debe ser **filtrado para que solo pasen las frecuencias bajas**. Esto crea un golpe profundo con cuerpo sin dominar el resto de la mezcla.

```haskell
-- Kick con filtrado característico
d1 $ sound "bd*4"
  # gain 0.9
  # lpf (slow 8 $ range 90 120 sine)
  # shape 0.25
  # room 0.3
  # size 0.4

-- Kick con modulación de cutoff
d1 $ sound "bd*4"
  # lpf 115
  # cutoff (slow 16 $ range 80 110 perlin)
  # attack 0.05
  # decay 0.3
  # sustain 0.4
  # release 0.3
```

#### Hi-Hats Sutiles y Variados

Generalmente a contratiempo (off-beat), con **variaciones sutiles en velocidad y paneo dinámico**. Evita la monotonía usando LFOs y probabilidades.

```haskell
-- Hi-hats con modulación orgánica
d2 $ sometimesBy 0.3 (|+ speed "0.9 1.1")
  $ sound "hh*8"
  # gain 0.6
  # lpf (range 2000 4000 $ perlin)
  # pan (slow 8 $ range 0.3 0.7 sine)
  # room 0.4
  # size 0.6

-- Hi-hats con contratiempo
d2 $ sound "~ hh ~ hh ~ hh ~ hh"
  # gain 0.6
  # lpf 4000
  # pan (slow 8 $ sine)
```

#### Percusión Adicional Sutil

Shakers y rims en capas con **niveles de ganancia bajos** y paneo para integrarse. Deben aparecer y desaparecerse ocasionalmente.

```haskell
-- Percusión con aparición probabilística
d3 $ whenmod 8 6 (# gain 0.5)
  $ sound "rim ~ shaker ~ perc ~"
  # gain 0.3
  # room 0.5
  # pan (slow 8 sine)

-- Percusión aleatoria sutil
d3 $ degradeBy 0.6
  $ sound "perc*8"
  # n (irand 8)
  # gain 0.4
  # pan rand
  # lpf (range 1000 3000 $ perlin)
```

#### Principio de Mezcla No-Dominante

**Ningún sonido debe dominar**. Los niveles de ganancia están cuidadosamente balanceados para que todos los elementos se mezclen sutilmente.

### 2. Bajo Profundo y con Movimiento

Sub-bass con **modulación sutil** usando filtros modulados por Perlin noise o LFOs lentos para crear movimiento orgánico "subacuático".

```haskell
-- Bass con modulación Perlin (subacuático)
d4 $ note "0 [~ 3] [~ 5] ~"
  # sound "bass"
  # gain 0.8
  # lpf (slow 8 $ range 60 120 perlin)
  # shape 0.3
  # cutoff (range 80 120 sine)
  # room 0.2
  # size 0.5
  # crush (slow 32 $ range 0 2 perlin)

-- Bass line melódico sutil
d4 $ slow 2
  $ note "0 3 5 7"
  # sound "superpwm"
  # gain 0.7
  # lpf (slow 4 $ range 80 150 sine)
  # attack 0.2
  # decay 0.4
  # sustain 0.6
  # release 0.8
  # room 0.3
```

### 3. Acordes Atmosféricos y Jazzy

Los acordes son una seña de identidad, a menudo **extendidos** (Ebm9, Bbm7, Abmaj7) con **influencia del jazz y deep house**.

```haskell
-- Progresión típica Dub Techno
d5 $ slow 4
  $ note "[3'min9 8'maj7 10'min7]"
  # sound "superpwm"
  # gain 0.6
  # attack 0.6
  # release 2.5
  # lpf (range 800 2500 $ slow 8 perlin)
  # room 0.8
  # size 0.9
  # delay 0.6
  # delayfb 0.7

-- Pads largos y profundos
d5 $ slow 8
  $ note "0'min9"
  # sound "superpwm"
  # gain 0.5
  # attack 2
  # release 6
  # lpf 1500
  # room 0.9
  # size 1
  # delay 0.8
  # delayfb 0.8
```

**Características clave:**

- Envolventes largas (attack y release amplios)
- Reverb espaciosa (room amplio con size grande)
- Delays paralelos con feedback alto
- Inversiones automáticas para variación sin complejidad melódica

### 4. Texturas y Capas Ambientales

La creación de **atmósfera envolvente y texturas** es crucial para el género.

```haskell
-- Ruido filtrado atmosférico
d6 $ slow 4
  $ sound "noise"
  # gain 0.2
  # hpf (slow 32 $ range 200 1000 perlin)
  # lpf (slow 64 $ range 400 2000 sine)
  # room 0.9
  # size 0.8

-- Ruido granular (textura evolutiva)
d6 $ striate 64
  $ sound "noise"
  # gain 0.15
  # lpf (slow 16 $ range 300 1500 perlin)
  # pan (slow 8 sine)
  # room 0.8

-- Clicks y crackles (vinilo/cinta)
d7 $ degradeBy 0.7
  $ sound "click*16"
  # gain 0.1
  # speed (range 0.5 2 $ rand)
  # pan rand
  # crush 8
```

**Técnicas adicionales:**

- Grabaciones de campo (lluvia, ciudad, viento)
- Elementos que aparecen y desaparecen ocasionalmente
- Melodías sutiles que se activan condicionalmente

### 5. Delays y Reverbs Característicos

Son los **efectos más distintivos** del Dub Techno.

```haskell
-- Delay modulado (movimiento orgánico)
d9 $ sound "dubhit*2"
  # delay (range 0.3 0.8 $ slow 8 perlin)
  # delaytime (range 0.2 0.6 $ slow 16 sine)
  # delayfb (range 0.6 0.9 $ slow 12 sine)
  # room 0.7
  # size 0.9
  # gain 0.4

-- Delay en cadena (múltiples repeticiones)
d9 $ sound "~ cp ~ ~"
  # delay 0.8
  # delaytime (1/8)
  # delayfb 0.85
  # lpf (slow 8 $ range 1000 4000 sine)
  # gain 0.5

-- Reverb infinita (experimental)
d10 $ sound "dubhit"
  # room 0.99
  # size 1
  # delay 0.9
  # delayfb 0.95
  # gain 0.3
```

**Aspectos clave:**

- Delays en cadena con feedback alto
- Delays paralelos que se activan ocasionalmente
- Reverbs amplias y espaciosas
- Automatizar y modular parámetros constantemente
- Técnica: usar señal wet del reverb/delay, grabarla y manipularla

### 6. Evolución Continua y Anti-Loop

Se evita la monotonía del loop mediante **variación constante**.

```haskell
-- Modulación cruzada de múltiples parámetros
dAll $ (# lpf (slow 32 $ range 600 3000 perlin))
     . (# gain (slow 24 $ range 0.7 1 sine))
     . (# delay (slow 48 $ range 0.2 0.6 perlin))

-- Variación probabilística
d2 $ sometimesBy 0.2 (# crush 1.5)
  $ often (# speed 1.1)
  $ sound "hh*8"
  # gain 0.6

-- Cambios sutiles cada 8 compases
d1 $ every 8 (# lpf 100)
  $ sound "bd*4"
  # gain 0.9
  # lpf 120

-- Elementos que aparecen/desaparecen
d8 $ whenmod 16 12 silence
  $ sound "pad"
  # gain 0.5

-- Degradación gradual
d3 $ degradeBy (slow 16 $ range 0 0.7 saw)
  $ sound "perc*8"
  # gain 0.4
```

**Técnicas de evolución:**

- LFOs (`sine`, `saw`, `tri`) con modulación lenta
- Perlin noise para cambios orgánicos
- Funciones de probabilidad (`sometimes`, `often`, `rarely`)
- Modulaciones lentas (`slow 16`, `slow 32`, `slow 64`)

### 7. Mezcla y Procesamiento Avanzado

#### Compresión Suave

```haskell
-- Compresión suave (simulada)
dAll $ (# shape 0.3 # gain 0.8)

-- Saturación tipo cinta
dAll $ (# shape (slow 16 $ range 0.2 0.4 sine))
```

#### Emulación de Hardware Vintage

```haskell
-- Bitcrushing sutil (textura vintage)
dAll $ (# crush (slow 32 $ range 0 1.5 perlin))

-- EQ global
d2 $ sound "hh*8" # hpf 200 # gain 0.6
d5 $ note "0'min7" # sound "superpwm" # hpf 150 # gain 0.7
```

#### Modulación Cruzada

Usar un LFO para modular múltiples parámetros simultáneamente crea interacciones complejas y orgánicas.

```haskell
-- Phasing (dos capas desincronizadas)
d5 $ stack [
  note "0'min7" # sound "superpwm",
  slow 1.01 $ note "0'min7" # sound "superpwm" # gain 0.6
]
```

#### Experimentación y "Accidentes Felices"

Se anima a **experimentar con efectos de forma extrema**, grabar y remuestrear los resultados para descubrir sonidos únicos.

```haskell
-- Reverse elements
d8 $ every 4 rev
  $ sound "cymbal"
  # speed "-1"
  # gain 0.6
  # room 0.8

-- Chopping y rearranging
d7 $ chop 16
  $ sound "ambient"
  # gain 0.4
  # room 0.7

-- Granular synthesis
d6 $ striate 128
  $ sound "pad"
  # speed 0.5
  # gain 0.3
  # room 0.9
```

### 8. Rangos de Tempo por Subgénero

```haskell
-- Deep Dub Techno: 115-118 BPM
setcps (115/60/4)

-- Classic Dub Techno: 118-122 BPM
setcps (118/60/4)

-- Minimal Dub: 120-124 BPM
setcps (122/60/4)

-- Modulación sutil del tempo (efecto cinta vintage)
setcps (slow 16 $ range 0.46 0.52 sine)
```

## Estructura Típica de un Track

### INTRO (8-16 compases) - Minimalista

```haskell
do
  d1 $ sound "bd*4" # gain 0.9 # lpf 120
  d2 $ sound "hh*8" # gain 0.6
  d6 $ sound "noise" # gain 0.2 # lpf 1000 # room 0.9
```

### DESARROLLO (32 compases) - Construcción gradual

```haskell
do
  d1 $ sound "bd*4" # gain 0.9 # lpf 120
  d2 $ sound "hh*8" # gain 0.6
  d3 $ sound "rim*2 shaker*3" # gain 0.4
  d4 $ note "0 [~ 3]" # sound "bass" # gain 0.8 # lpf 100
  d6 $ sound "noise" # gain 0.2 # room 0.9
```

### PEAK (32 compases) - Todos los elementos

```haskell
do
  d1 $ sound "bd*4" # gain 0.9 # lpf 120
  d2 $ sound "hh*8" # gain 0.6
  d3 $ sound "rim*2 shaker*3" # gain 0.4
  d4 $ note "0 [~ 3]" # sound "bass" # gain 0.8 # lpf 100
  d5 $ slow 2 $ note "0'min7 3'maj7" # sound "superpwm" # gain 0.7 # room 0.8
  d6 $ sound "noise" # gain 0.2 # room 0.9
  d7 $ sound "rain" # gain 0.3
  d9 $ sound "dubhit*2" # delay 0.7 # delayfb 0.8
```

### BREAKDOWN (16 compases) - Reducción

```haskell
do
  d1 $ sound "bd*4" # gain 0.8 # lpf 100
  d5 $ slow 4 $ note "0'min9" # sound "superpwm" # gain 0.6
  d6 $ sound "noise" # gain 0.25 # room 0.95
  d2 silence
  d3 silence
  d4 silence
```

### OUTRO (16 compases) - Fade out

```haskell
do
  d1 $ sound "bd*4" # gain (slow 16 $ range 0.9 0 saw)
  d5 $ note "0'min7" # sound "superpwm" # gain (slow 16 $ range 0.6 0 saw)
  d6 $ sound "noise" # gain (slow 16 $ range 0.2 0 saw)
```

## Filosofía y Principios del Dub Techno

1. **Ningún sonido debe dominar** - Balance sutil entre todos los elementos
2. **Movimiento constante** - Todo modula lentamente (LFOs, Perlin noise)
3. **Espacio es parte del ritmo** - El silencio y la reverb crean profundidad
4. **Evolución orgánica** - Evitar loops mecánicos, buscar variación
5. **Textura sobre melodía** - El ambiente es tan importante como las notas
6. **Delays y reverbs como instrumentos** - No son efectos, son parte de la composición
7. **Imperfección elegante** - Abraza el ruido, el crackle, la saturación
8. **Profundidad sobre volumen** - Graves profundos, mezcla espaciosa

## Artistas de Referencia

- Basic Channel / Maurizio
- Deepchord / Echospace
- Rhythm & Sound
- Fluxion
- Intrusion
- King Tubby
- Lee "Scratch" Perry
