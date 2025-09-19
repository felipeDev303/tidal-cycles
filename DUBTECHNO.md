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

## Artistas de Referencia

- Basic Channel / Maurizio
- Deepchord / Echospace
- Rhythm & Sound
- Fluxion
- Intrusion
- King Tubby
- Lee "Scratch" Perry
