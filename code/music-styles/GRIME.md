# Guía Maestra de Producción de Grime en TidalCycles

## Introducción: El Grime como Fenómeno Tecno-Cultural

El **grime** no es solo un género musical: es una **banda sonora de resistencia digital**, nacida en los márgenes del East London a principios de los 2000. Surge como una fusión cruda del **UK garage**, el **jungle**, el **hip hop** y la **música de videojuegos**, creada por una generación que creció entre dos pantallas: la del televisor (jugando) y la del PC (produciendo beats).

### La Estética "Dirty Digital"

> "Usé Sample Vision... tenía 200 KB para toda la música del juego. Tenía que recortar los sonidos hasta que sonaran sucios." — Dylan Beale

La "**suciedad digital**" del grime no fue una decisión estética inicial, sino una **consecuencia técnica**: baja resolución de audio, sampleo corto, compresión forzada. Esa textura _pixelada_ se volvió identidad.

### Filosofía Central: Low-Tech Futurism

El grime es el **futuro hecho con herramientas del pasado**. En lugar de esconder las limitaciones tecnológicas, las **usa como textura estética**:

- Bitcrushing (16 → 8 bits)
- Sampleo corto (menos de 1 segundo)
- Fallos de cuantización intencional
- Repetición mecánica → sensación de "loop infinito"
- Frialdad digital → símbolo del aislamiento urbano

## Contexto Histórico y Cultural

### El Ecosistema Tecnológico (Finales 90s - Principios 2000s)

**Hardware y Software Disponible:**

- PlayStation Music 2000
- FruityLoops 3–4
- Cubase VST
- Reason
- Samplers baratos (Akai S-series, Roland SP)
- Consolas: Sega Mega Drive, Super Nintendo, PlayStation, PS2

**Cultura Gamer y Producción:**

Los productores grime crecieron **jugando y hackeando**:

- Modificaban consolas, usaban samples de _Mario Paint_ o _Music 2000_ (JME)
- Grababan en disquetes, usaban emuladores de sonidos
- Experimentaban con la misma curiosidad técnica que un programador

Por eso el grime tiene una **mentalidad hacker**: romper sistemas, reutilizar herramientas, crear con límites.

### Parentesco Sonoro: Grime ≈ Chip Music

| Elemento        | Videojuego 90s                  | Grime 2000s                                              |
| --------------- | ------------------------------- | -------------------------------------------------------- |
| **Timbre**      | Sintetizadores FM / 8-bit       | Sintetizadores digitales agudos (Yamaha DX, FruityLoops) |
| **Memoria**     | Limitada (200 KB–1 MB)          | PCs baratos, loops cortos                                |
| **Textura**     | Lo-fi, saturada                 | Lo-fi, distorsionada                                     |
| **Composición** | Loop repetitivo, tempo fijo     | Loop 140 BPM, patrón repetido                            |
| **Energía**     | Lúdica, ansiosa                 | Urbana, agresiva                                         |
| **Función**     | Fondo dinámico (nivel, combate) | Base para el _MC battle_                                 |

## Fundamentos Técnicos del Grime

### 1. Tempo Característico: 140 BPM

El **tempo de 140 BPM** es fundamental para el feel del grime. Es el punto medio entre:

- Jungle (170 BPM)
- Hip Hop (90 BPM)

Esta configuración NO es negociable — es parte de la identidad del género.

```haskell
-- Configuración básica de tempo grime
setcps (140/60/4)
```

### 2. Estructura Musical: La Mecánica del Beat Grime

**Componentes Esenciales:**

- **Ritmo roto (broken beat)**: percusión sincopada, sin linealidad
- **Melodías cortadas**: breves frases de 3–5 notas, repetidas como "loops de jefe final"
- **Bajos monofónicos**: programados manualmente, no tocados
- **Espacio para el MC**: no llenar todo el espectro sonoro

**Estructura Típica:**

```text
Intro (8 compases)   - Minimalista
Drop (16 compases)   - MC entra
Break (4 compases)   - Solo bass
Reload (16 compases) - Energía máxima
Outro (8 compases)   - Fade out
```

### 3. Tabla de Elementos Sonoros

| Elemento       | Descripción                                | Técnica                                       |
| -------------- | ------------------------------------------ | --------------------------------------------- |
| **Tempo**      | 137–143 BPM                                | Similar al dubstep temprano, pero más rígido  |
| **Drums**      | Kick pesado y seco, snare metálica         | Sampleado de TR-808/909 o reciclado de jungle |
| **Bass**       | Sub wobble o líneas sintéticas monofónicas | Sinusoidal con LFO lento, o square saturado   |
| **Melodía**    | Sintetizadores agresivos, riffs simples    | Escalas menores o modos frigios               |
| **Textura**    | Glitch, clipping, distorsión digital       | Bouncing intencional a baja tasa de bits      |
| **Estructura** | Ciclos de 8 o 16 compases                  | No hay "chorus", energía repetitiva           |

## Implementación en TidalCycles

### Configuración Inicial

```haskell
-- Tempo clásico grime: 137-143 BPM (140 es el estándar)
setcps (140/60/4)

-- El tempo de 140 es el punto medio entre jungle (170) y hip hop (90)
-- Esta configuración es FUNDAMENTAL para el feel del grime
```

## Elementos Sónicos Característicos del Grime

### 1. DRUMS - Broken Beat y Sincopación

#### Patrón Básico 1-2 (Kick en 1 y 3, Snare en 2 y 4)

```haskell
-- Patrón básico
d1 $ sound "bd ~ sn ~ bd ~ sn ~"
   # gain 1.2

-- Kick pesado y seco + snare metálica (estilo 808/909 sampleado)
d1 $ stack [
  sound "bd*2 ~ bd ~"
    # gain 1.3
    # speed 0.9,
  sound "~ ~ sn ~ ~ ~ sn ~"
    # gain 1.1
    # speed 1.2
]
```

#### Broken Beat: Ritmo Fragmentado

```haskell
-- Broken beat típico del grime
d1 $ sound "bd ~ ~ bd ~ sn ~ bd"
   # gain 1.2

-- Drum pattern completo con swing
d1 $ stack [
  sound "bd bd ~ bd ~ bd ~ ~" # gain 1.3,
  sound "~ ~ sn ~ ~ sn:1 ~ sn" # gain 1.2,
  sound "hh(11,16)" # gain 0.8 # speed 1.2,
  sound "~ ~ ~ ~ rim ~ ~ ~" # gain 0.7
] # nudge (range 0 0.01 $ rand) -- Micro-timing para humanización
```

#### Hi-Hats Sincopados

```haskell
-- Hi-hats con patrón euclidiano
d2 $ sound "hh(5,8)"
   # gain (range 0.7 1.1 $ fast 4 sine)
   # speed (range 1.1 1.3 $ slow 2 sine)

-- Hi-hats rápidos (sensación de urgencia)
d2 $ sound "hh*16"
   # gain (range 0.6 0.9 $ fast 8 rand)
   # speed (range 0.9 1.2 $ rand)
   # pan (range 0.3 0.7 $ slow 3 sine)
```

#### Características de los Drums Grime

**Kick:**

- Pesado y seco
- Comprimido agresivamente
- Frecuencias dominantes: 60-100 Hz
- Sin reverb (mantiene la claridad)

**Snare:**

- Metálica y cortante
- Sample de 808/909 procesado
- Frecuencias agudas enfatizadas (3-5 kHz)
- Corta y seca

**Hi-Hats:**

- Entrecortados y sincopados
- Patrones euclidianos para complejidad
- Variación constante en velocidad y ganancia
- Paneo sutil para amplitud estéreo

### 2. SUB-BASS - Monofónico y Wobble

El bajo en grime es **monofónico, profundo y con movimiento**. La técnica del "wobble" (oscilación del filtro) es característica.

#### Sub-Bass Sinusoidal Puro (40-100 Hz)

```haskell
-- Sub-bass fundamental
d3 $ note "c2 ~ ~ ~ ds2 ~ g2 ~"
   # s "sine"
   # lpf 120
   # gain 1.6
   # sustain 0.8
```

#### Wobble Bass con LFO (Técnica Clásica Grime)

```haskell
-- Wobble bass característico
d3 $ note "c2 ~ ds2 ~ g2 ~ as2 ~"
   # s "supersquare"
   # lpf (range 80 400 $ slow 2 sine)
   # lpq 0.15
   # gain 1.5
   # detune 0.2
```

#### Reese Bass (Dos Ondas Desafinadas)

```haskell
-- Reese bass con movimiento
d3 $ note "c2(3,8)"
   # s "supersaw"
   # lpf (range 100 300 $ slow 1 saw)
   # lpq 0.2
   # gain 1.4
   # detune 0.5
```

#### Bass Line Típica (Progresión C → D# → G → A#)

```haskell
-- Progresión clásica grime
d3 $ note "c2 ~ ds2 ~ g2 ~ as2 ~"
   # s "superpwm"
   # lpf 200
   # gain 1.5
   # shape 0.3 -- Saturación suave
```

**Características del Bass Grime:**

- **Monofónico**: Solo una nota a la vez
- **Rango**: 40-100 Hz (sub) + 100-250 Hz (armónicos)
- **Movimiento**: LFO en filtro (slow 1-4)
- **Saturación**: Shape 0.2-0.4 para agregar armónicos
- **Sin reverb**: Mantiene claridad y pegada

### 3. MELODÍAS - Sintetizadores Agresivos y 8-Bit

Las melodías en grime son **breves, repetitivas y agresivas**, con fuerte inspiración en música de videojuegos.

#### Escala Menor Armónica (Oscura y Tensa)

```haskell
-- Escala característica
d4 $ note (scale "harmonicMinor" "0 3 5 7")
   # s "supersquare"
   # lpf 2000
   # gain 0.9
   # attack 0.01
   # release 0.3
```

#### Riff Estilo Videojuego (3-5 Notas Repetidas)

```haskell
-- Riff minimalista
d4 $ note "c5 ~ ds5 g5 ~ as5 ~ ~"
   # s "superchip"
   # speed (range 0.9 1.1 $ slow 4 sine)
   # gain 0.9
   # crush 6 -- Bitcrushing para textura digital
```

#### Stabs Metálicos (Estilo FM/Yamaha DX)

```haskell
-- Stabs agresivos
d4 $ note "c5 ~ ~ ~ ds5 ~ ~ ~ g5 ~ ~ ~ as5 ~ ~ ~"
   # s "supersquare"
   # lpf 5000
   # hpf 800
   # gain 1.2
   # attack 0.001
   # release 0.15
   # room 0.3
```

#### Lead Agresivo con Distorsión

```haskell
-- Lead distorsionado
d4 $ note (scale "phrygian" "<0 3 5 7>")
   # s "supersaw"
   # lpf 3500
   # gain 0.9
   # shape 0.6 -- Distorsión digital
   # room 0.2
```

**Principios de las Melodías Grime:**

- **Brevedad**: 3-5 notas máximo
- **Repetición**: Loop constante sin variación armónica
- **Registro**: Agudo (C5-C6) para cortar en la mezcla
- **Timbre**: Digital, metálico, agresivo
- **Escalas**: Menor armónica, frigio, menor natural
- **Procesamiento**: Bitcrushing, distorsión, filtrado agresivo

### 4. TEXTURA "DIRTY DIGITAL" - Glitch y Ruido

La textura sucia es la **firma del grime**. No es un defecto, es una elección estética.

#### Glitch Aleatorio (Errores Intencionales)

```haskell
-- Glitch controlado
d5 $ sound "glitch(5,16)"
   # speed (range 0.7 1.3 $ rand)
   # crush (range 3 8 $ slow 4 sine)
   # gain 0.6
   # pan rand
```

#### Bitcrushing Severo (Reducción 16→8 bits)

```haskell
-- Bitcrushing característico
d4 $ note "c5*4"
   # s "superpiano"
   # crush 4
   # gain 0.8
   # speed 0.8
```

#### Clipping Intencional (Saturación Extrema)

```haskell
-- Overload digital
d3 $ note "c2*2"
   # s "superpwm"
   # lpf 150
   # gain 2.5 -- Overload intencional
   # shape 0.9
```

#### Sample Recortado (Menos de 1 Segundo)

```haskell
-- Chopping agresivo
d6 $ chop 32 $ sound "breaks165"
   # gain 0.7
   # speed (range 0.5 1.5 $ rand)
   # crush 6
```

**Técnicas de Texturización:**

- **Crush**: 3-8 (reducción de bits)
- **Shape**: 0.6-0.9 (saturación/clipping)
- **Speed random**: Variación de pitch caótica
- **Chop**: Fragmentación de samples (16-32 divisiones)
- **Degradación**: `degradeBy` para dropout ocasional

### 5. ESPACIALIZACIÓN MÍNIMA - Menos es Más

**IMPORTANTE**: El grime NO usa mucho reverb/delay. El objetivo es **dejar ESPACIO para el MC**.

#### Reverb Sutil Solo en Elementos Secundarios

```haskell
-- Reverb minimalista
d7 $ sound "rim ~ ~ ~ rim ~ ~ ~"
   # room 0.2
   # size 0.3
   # gain 0.7
```

#### Delay Corto en Hi-Hats

```haskell
-- Delay sutil
d2 $ sound "hh(7,16)"
   # delay 0.3
   # delaytime (1/16)
   # delayfb 0.2
   # gain 0.8
```

**Reglas de Espacialización Grime:**

- **Room**: 0.1-0.3 máximo (excepto en transiciones)
- **Delay**: Corto (1/16 o 1/8), feedback bajo (0.2-0.4)
- **Prioridad**: Dejar espacio frecuencial y espacial para la voz
- **Filosofía**: Seco y directo, no atmosférico

## Escalas y Progresiones Grime

### Escalas Características

```haskell
-- Escala menor natural (C D Eb F G Ab Bb)
d4 $ note (scale "minor" "0 2 3 5 7 8 10")
   # s "supersquare"
   # gain 0.8

-- Escala menor armónica (más tensión)
d4 $ note (scale "harmonicMinor" "0 3 5 7")
   # s "supersquare"
   # gain 0.8

-- Frigio (sonido árabe/oscuro)
d4 $ note (scale "phrygian" "0 1 3 5 7")
   # s "supersquare"
   # gain 0.8
```

### Progresión Clásica Grime: i - bIII - v - bVII

En C: Cm - Eb - Gm - Bb

```haskell
-- Progresión armónica típica
d4 $ note "<0'min 3'maj 7'min 10'maj>"
   # s "superpwm"
   # lpf 2000
   # gain 0.7
```

**Características Armónicas:**

- **Modos**: Menor natural, menor armónica, frigio
- **Tensión**: Sin resolución tonal (loop infinito)
- **Progresiones**: Movimientos de terceras menores
- **Influencia**: Hip hop + música árabe/oriental

## Estructura de Track Grime

### INTRO (8 compases) - Minimalista

```haskell
do
  d1 $ sound "bd*2 ~ bd ~" # gain 1.2
  d2 $ sound "hh(5,8)" # gain 0.7
  d3 silence
```

### DROP 1 (16 compases) - MC Entra

```haskell
do
  d1 $ sound "bd bd ~ bd ~ sn ~ bd" # gain 1.3
  d2 $ sound "hh*16" # gain 0.8
  d3 $ note "c2 ~ ds2 ~ g2 ~ as2 ~"
     # s "superpwm" # lpf 200 # gain 1.5
```

### BREAK (4 compases) - Solo Bass

```haskell
do
  d1 silence
  d2 silence
  d3 $ note "c2*4" # s "sine" # lpf 100 # gain 1.6
```

### DROP 2 / RELOAD (16 compases) - Energía Máxima

```haskell
do
  d1 $ sound "bd bd ~ bd ~ bd sn bd" # gain 1.4
  d2 $ sound "hh(11,16)" # gain 0.9 # speed 1.3
  d3 $ note "c2 ~ ds2 ~ g2 ~ as2 ~"
     # s "supersquare"
     # lpf (range 100 400 $ slow 1 sine)
     # gain 1.5
  d4 $ note "c5 ~ ds5 g5 ~ as5 ~ ~"
     # s "supersquare"
     # gain 1.0
     # crush 5
```

### OUTRO (8 compases) - Fade Out

```haskell
do
  d1 $ sound "bd*2 ~ bd ~"
     # gain (slow 8 $ range 1.2 0 saw)
  d2 $ sound "hh(5,8)"
     # gain (slow 8 $ range 0.7 0 saw)
  d3 silence
  d4 silence
```

## Técnicas Avanzadas - Live Coding Grime

### 1. Euclidean Rhythms para Broken Beats Complejos

```haskell
-- Ritmos euclidianos superpuestos
d1 $ sound "bd(5,8) ~ sn(3,8) ~" # gain 1.2
```

### 2. Polyrhythm (Ritmos Superpuestos)

```haskell
-- Polirritmia característica
d1 $ stack [
  sound "bd(3,8)" # gain 1.3,
  sound "sn(5,8)" # gain 1.1,
  sound "hh(13,16)" # gain 0.7
]
```

### 3. Probabilidad (Variación Orgánica)

```haskell
-- Hi-hats con probabilidad
d2 $ sound "hh*16?"
   # gain 0.8
   # speed (range 1 1.3 $ rand)
```

### 4. Stutter/Glitch Effect

```haskell
-- Stutter característico
d4 $ stut 4 0.7 0.125
   $ note "c5"
   # s "supersquare"
   # gain 0.9
   # crush 6
```

### 5. Phasing (Desincronización Sutil)

```haskell
-- Efecto de phasing
d1 $ stack [
  sound "bd*4" # gain 1.2,
  slow 1.02 $ sound "bd*4" # gain 0.8 # pan 0.3
]
```

### 6. Degradación Gradual

```haskell
-- Elementos que desaparecen gradualmente
d2 $ degradeBy (slow 8 $ range 0 0.7 saw)
   $ sound "hh*16"
   # gain 0.8
```

### 7. Reverse y Chopping

```haskell
-- Manipulación de samples
d6 $ every 4 rev
   $ chop 16
   $ sound "breaks165"
   # gain 0.9
   # speed 1.2
```

## Técnicas Generativas - "Boss Level Music"

### Bass Line Algorítmica con Perlin Noise

```haskell
-- Bass generativo
d3 $ note (scale "minor" $ segment 8 $ range 0 7 $ perlin)
   # s "superpwm"
   # lpf 250
   # gain 1.4
   # octave 2
```

### Melodía Evolutiva

```haskell
-- Melodía que evoluciona
d4 $ note (scale "phrygian" $ slow 4 $ run 8)
   # s "supersquare"
   # speed (range 0.8 1.2 $ slow 8 sine)
   # crush 5
   # gain 0.9
```

### Hi-Hats Caóticos pero Controlados

```haskell
-- Hi-hats con Perlin noise
d2 $ sound "hh*16"
   # speed (range 0.9 1.4 $ segment 16 $ perlin)
   # gain (range 0.5 1 $ segment 8 $ perlin)
   # pan (slow 2 sine)
```

## Transiciones y "Reloads"

### Buildup con Pitch Rise

```haskell
-- Buildup característico
d4 $ note "c5*16"
   # s "supersquare"
   # speed (slow 4 $ range 1 2 saw)
   # gain (slow 4 $ range 0.5 1.2 saw)
   # crush 4
```

### Drop Explosivo (Silence → Full)

```haskell
-- Drop potente
do
  hush
  d1 $ sound "bd bd ~ bd ~ bd sn bd" # gain 1.5
  d2 $ sound "hh*16" # gain 1
  d3 $ note "c2*2" # s "sine" # lpf 100 # gain 2
```

### Reverse Cymbal para Transición

```haskell
-- Cymbal invertido
d8 $ sound "cymbal"
   # speed "-1"
   # gain 0.9
   # room 0.5
```

### Roll de Snare (Cada 8 Compases)

```haskell
-- Snare roll periódico
d1 $ every 8 (const $ sound "sn*16" # gain 1.2)
   $ sound "bd ~ sn ~ bd ~ sn ~"
```

## Sidechain Simulation - Ducking

```haskell
-- El kick "empuja" los demás elementos
d1 $ sound "bd*4" # gain 1.4

d5 $ note "c4'min7"
   # s "superpwm"
   # gain (segment 4 $ range 0.4 1 $ slow 1 saw)
   # lpf 1500
```

## Ejemplo Completo - Track Grime

```haskell
setcps (140/60/4)

do
  -- Drums
  d1 $ sound "bd bd ~ bd ~ sn ~ bd"
     # gain 1.3

  -- Hi-hats
  d2 $ sound "hh(11,16)"
     # gain 0.8
     # speed (range 1.1 1.3 $ slow 4 sine)

  -- Sub-bass
  d3 $ note "c2 ~ ds2 ~ g2 ~ as2 ~"
     # s "supersquare"
     # lpf (range 100 350 $ slow 2 sine)
     # gain 1.5

  -- Lead
  d4 $ note "c5 ~ ds5 g5 ~ as5 ~ ~"
     # s "supersquare"
     # gain 0.9
     # crush 5
     # room 0.2

  -- Glitch texture
  d5 $ sound "glitch(5,16)"
     # speed (range 0.8 1.2 $ rand)
     # crush 6
     # gain 0.5
```

## Comandos de Control Live

```haskell
-- Silenciar todo
hush

-- Silenciar pista individual
d1 silence

-- Solo una pista
solo 1

-- Quitar solo
unsolo 1

-- Transición suave (8 ciclos)
xfadeIn 1 8 $ sound "bd*4"

-- Resetear tempo
setcps (140/60/4)
```

## Samples Recomendados (SuperDirt)

**Drums:**

- bd, sn, hh, rim, cp, clap

**Synths:**

- supersquare, supersaw, superpwm, superchip

**Bass:**

- sine (para sub-bass puro)

**FX:**

- glitch, noise

**Breaks:**

- breaks165, jungle

## Filosofía de Producción Grime

### 1. MINIMALISMO AGRESIVO

Pocos elementos, cada uno con impacto máximo. La potencia viene de la **claridad**, no de la saturación.

### 2. ESPACIO PARA EL MC

No llenar todo el espectro sonoro. El beat es el **ring** donde el MC pelea.

### 3. TENSIÓN CONSTANTE

Loop infinito sin resolución tonal. La música debe mantener una **ansiedad perpetua**.

### 4. DIRTY DIGITAL

Abrazar las imperfecciones (crush, clip, glitch). La textura "sucia" es **identidad**, no defecto.

### 5. REPETICIÓN HIPNÓTICA

8-16 compases en loop, como un **nivel de videojuego**. La variación viene del MC, no del beat.

### 6. LOW-TECH FUTURISM

Sonido futurista con herramientas limitadas. La precariedad tecnológica se convierte en **potencia expresiva**.

### 7. DIY ATTITUDE

Experimentación sin reglas. El grime es **música de la calle, hecha en la calle**.

### 8. LA ESTÉTICA DEL "BOSS LEVEL"

El beat funciona como un **jefe final infinito**: sin cadencia, sin fin. Cada MC que entra es un nuevo combate.

## Grime y Videojuegos: Relación Generacional

### El Simbolismo del "Boss Level Music"

Los primeros beats grime funcionan como pantallas de jefe:

- _Eskimo_ (Wiley, 2002) es una "pantalla de jefe" infinita
- Cada MC que entra al beat es un nuevo enemigo
- Los "reloads" del DJ equivalen a _reiniciar el nivel_

**En términos simbólicos:**

> El grime convierte la vida urbana en un videojuego de supervivencia.

### Lógica Modular Compartida

Tanto la música de videojuegos como el grime comparten:

- Crear sensación de **movimiento con pocos elementos**
- Enfatizar la **repetición hipnótica** como forma de tensión
- Cada beat parece un **nivel**, cada MC una **batalla**

## TidalCycles y la Mentalidad Hacker del Grime

### Live Coding como Performance Grime

El grime siempre tuvo algo de **freestyle en vivo**. En TidalCycles, el **live coding** es una extensión natural:

- Puedes improvisar patrones como un MC improvisa versos
- Puedes **mutar el loop cada 16 compases** para generar tensión
- Cada cambio de código se convierte en una performance

### El Grime "Algorítmico"

Es una forma de **devolver el grime a su esencia**: el control total de la máquina y el caos digital.

| Dimensión      | En el Grime Clásico              | En TidalCycles                     |
| -------------- | -------------------------------- | ---------------------------------- |
| **Producción** | Limitaciones técnicas (hardware) | Limitaciones conceptuales (código) |
| **Estética**   | Digital sucio, callejero         | Generativo, repetitivo, glitch     |
| **Actitud**    | DIY, underground                 | Live coding como performance       |
| **Espacio**    | Londres Este                     | El entorno algorítmico del laptop  |

## Recursos y Referencias

### Productores para Estudiar

- **Wiley** - El padrino del grime
- **Dizzee Rascal** - Boy in da Corner (2003)
- **Jammer** - Lord of the Mics
- **Ruff Sqwad** - Producción colectiva
- **Terror Danjah** - Sonidos experimentales
- **Slaughter Mob** - Crew legendario
- **Roll Deep** - Movimiento colectivo

### Tracks de Referencia Esenciales

- Wiley - "Eskimo" (2002)
- Dizzee Rascal - "I Luv U" (2003)
- Skepta - "Shutdown" (2015)
- JME - "Serious" (2008)
- Novelist - "Take Time" (2015)

### Videojuegos con Influencia en Grime

- **Wolverine: Adamantium Rage** (1994) - Dylan Beale OST
- **Streets of Rage** series
- **Final Fantasy** series (samples usados por Dark0)
- **Mario Paint**
- **Music 2000** (PlayStation)

## Analogía: Grime vs Dub Techno

| Característica   | Dub Techno            | Grime                |
| ---------------- | --------------------- | -------------------- |
| **BPM**          | 118-122               | 140                  |
| **Textura**      | Cálida, envolvente    | Fría, digital        |
| **Espacialidad** | Máxima (reverb/delay) | Mínima (seco)        |
| **Filosofía**    | Meditativa, expansiva | Agresiva, contenida  |
| **Elementos**    | Muchos, sutiles       | Pocos, impactantes   |
| **Bajo**         | Profundo, modulado    | Monofónico, wobble   |
| **Función**      | Inmersión atmosférica | Base para voz/MC     |
| **Origen**       | Berlín, minimalismo   | Londres, videojuegos |

## Conclusión: El Grime en TidalCycles

El grime en TidalCycles no solo puede recrear el sonido, sino **su espíritu hacker**: transformar la precariedad tecnológica en potencia expresiva.

TidalCycles ofrece las herramientas perfectas para capturar la esencia del grime:

- **Patrones euclidianos** → broken beats
- **Funciones de probabilidad** → variación orgánica
- **Live coding** → performance como freestyle
- **Código como instrumento** → control total de la máquina

El grime es música **de la calle, para la calle**, hecha con lo que había a mano. TidalCycles continúa esa tradición: hacer música potente con **código abierto y laptop**.

---

**¡RELOAD!** 🔥

---

## Apéndice: Plantilla de Trabajo Grime

```haskell
-- GRIME TRACK TEMPLATE - TidalCycles
-- ====================================

-- TEMPO
setcps (140/60/4)

-- DRUMS (d1)
d1 $ sound "bd bd ~ bd ~ sn ~ bd" # gain 1.3

-- HI-HATS (d2)
d2 $ sound "hh(11,16)" # gain 0.8

-- SUB-BASS (d3)
d3 $ note "c2 ~ ds2 ~ g2 ~ as2 ~" # s "supersquare" # lpf 200 # gain 1.5

-- LEAD/MELODY (d4)
d4 $ note "c5 ~ ds5 g5 ~ as5 ~ ~" # s "supersquare" # crush 5 # gain 0.9

-- TEXTURE/GLITCH (d5)
d5 $ sound "glitch(5,16)" # crush 6 # gain 0.5

-- TRANSITIONS (d8)
-- Usar para builds, drops, reverses

-- CONTROL
-- hush            -- Silenciar todo
-- d1 silence      -- Silenciar d1
-- solo 1          -- Solo d1
-- unsolo 1        -- Quitar solo
```
