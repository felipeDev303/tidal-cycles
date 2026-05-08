# 4. Conceptos fundamentales: ciclos, patrones y eventos

## El ciclo

En lugar de BPM, Tidal mide el tiempo en **cycles per second (cps)**:

```haskell
setcps 0.6   -- 0.6 ciclos por segundo
setcps 1     -- 1 ciclo por segundo (~120 bpm si hay 2 negras por ciclo)
resetCycles  -- reinicia el contador de ciclos a 0
```

Un **ciclo** es el bucle global que Tidal usa como unidad de sincronía: todos los `d1..d16` comparten ese reloj. Cuando escribes:

```haskell
d1 $ sound "bd hh sn hh"
```

los cuatro samples se reparten **uniformemente** dentro de un ciclo. Si añades más, el ciclo no se alarga: cada paso se hace más corto. Por eso entre más pasos, más rápido suena.

## ¿Qué es un patrón?

> "Un `Pattern a` describe un mapeo periódico del tiempo a `a`."

Formalmente, en `Pattern.hs`:

```haskell
data Pattern a = Pattern { query :: State -> [Event a] }
```

Un patrón es esencialmente una **función**: dado un estado (que incluye un arco de tiempo y un mapa de controles), devuelve la lista de **eventos** activos en ese arco.

Esto tiene implicaciones profundas:

- Los patrones no son listas fijas de eventos: se *consultan* sobre intervalos arbitrarios.
- Un patrón puede ser infinito en el tiempo porque solo se calcula sobre el arco que se pide.
- Los patrones son **valores de primera clase**: se componen, se transforman, se aplican unos a otros.

## Tiempo racional, no flotante

Tidal usa números **racionales** (`Rational`) para el tiempo, no `Double`. Esto evita errores de redondeo y refleja una visión musical: las divisiones del compás son fracciones exactas (1/3, 1/4, 5/8...).

```haskell
type Time = Rational
```

## El `Arc`: un arco de tiempo

Un `Arc` es un par (inicio, fin):

```haskell
data ArcF a = Arc { start :: a, stop :: a }
type Arc   = ArcF Time
```

No representa un instante puntual sino una **duración**. Ideológicamente conecta con el *specious present*.

## Eventos

Cada evento tiene **dos arcos** y un valor:

```haskell
data EventF a b = Event { whole :: a, part :: a, value :: b }
type Event a    = EventF Arc a
```

- `whole` es la duración "ideal" del evento.
- `part` es la porción de ese evento que cae dentro del arco que estamos consultando.

Cuando un patrón cruza un límite de ciclo, un mismo evento `whole` puede aparecer dividido en varios `part`. Por ejemplo:

```text
queryArc (slow 2 $ pure 1) (Arc 0 2)
  ==> [(0>1)-2|1, 0-(1>2)|1]
```

El número `1` se reproduce una sola vez con `whole = (0,2)`, pero como Tidal corta los eventos en límites de ciclo, vemos dos `part`: `(0,1)` y `(1,2)`.

## Patrones digitales y analógicos

```haskell
data Nature = Analog | Digital
```

- **Digitales**: representan eventos discretos (notas, samples). Son lo que usas el 95% del tiempo.
- **Analógicos**: continuos (ondas: `sine`, `saw`, `cosine`, `perlin`). Útiles para barridos de filtro, paneo suave, etc.

Cuando se les pregunta por una región, los analógicos devuelven un único evento con valor *muestreado* en el centro de la región.

## Construir patrones desde cero

Antes de la mini-notación, hay constructores básicos en `Core.hs` y `Pattern.hs`:

```haskell
silence                           -- patrón vacío
pure "x"                          -- un evento por ciclo, valor "x"
fromList     ["a","b","c"]        -- un evento por ciclo cada uno
fastFromList ["a","b","c"]        -- comprime los tres en un ciclo
listToPat    ["a","b","c"]        -- alias de fastFromList
fromMaybes [Just "a", Nothing,
            Just "c"]             -- introduce huecos
```

## `ControlPattern` y `ValueMap`

El sonido se controla mediante **mapas clave/valor**:

```haskell
type ValueMap        = Map String Value
type ControlPattern  = Pattern ValueMap
```

Funciones como `s`, `sound`, `n`, `note`, `gain`, `pan`, `cutoff` producen `ControlPattern`. Se combinan con el operador `#` (ver [Operadores](06-haskell-y-operadores.md)).

```haskell
sound "bd sn" # gain "0.8 1" # pan "0 1"
```

## Cycles y `d1..d16`

Los *orbits* `d1`, `d2`, ..., `d16` son canales independientes. Cada uno toma un `ControlPattern` y lo envía al stream de OSC:

```haskell
d1 $ sound "bd*4"
d2 $ sound "~ cp ~ cp"
d3 $ n (irand 16) # sound "arpy(3,8)"

solo 2     -- solo d2
unsolo 2
mute 1     -- silencia d1
unmute 1
d3 silence -- detiene d3
hush       -- detiene todo
```

Los orbits no son solo "canales de mezcla": comparten ciertos **efectos globales** (delay, reverb) cuando se asignan a la misma `orbit`. Ver [Performance](11-performance.md).

Continúa con [Mini-notación](05-mini-notacion.md).
