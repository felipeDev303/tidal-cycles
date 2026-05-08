# 6. Haskell, tipos y operadores

Tidal está embebido en Haskell, así que entender unas pocas ideas de programación funcional ayuda mucho.

## Funciones puras y tipado

En Haskell **todo es una función pura**: dada la misma entrada, siempre devuelve la misma salida y no tiene efectos secundarios. No hay variables mutables ni bucles tradicionales; en su lugar hay **recursión** y **funciones de orden superior**.

Cada expresión tiene un **tipo** que puedes inspeccionar con `:t` en GHCi:

```haskell
:t sound
-- sound :: Pattern String -> ControlPattern

:t every
-- every :: Pattern Int -> (Pattern a -> Pattern a) -> Pattern a -> Pattern a

:t rev
-- rev :: Pattern a -> Pattern a
```

La regla práctica: si el compilador se queja, casi siempre es porque dos firmas no encajan. Lee los tipos.

## El operador `$`

`$` es probablemente el símbolo más usado en Tidal. Su firma es:

```haskell
($) :: (a -> b) -> a -> b
```

Es decir: **toma una función a la izquierda y un valor a la derecha**, y aplica la función al valor. Equivale a paréntesis pero **se lee de derecha a izquierda**:

```haskell
d1 $ sound "bd hh arpy"
-- equivale a:
d1 (sound "bd hh arpy")
```

En cadenas largas, evita una avalancha de paréntesis:

```haskell
d1 $ fast 2 $ rev $ sound "bd hh arpy"
-- equivale a:
d1 (fast 2 (rev (sound "bd hh arpy")))
```

Matemáticamente, `f $ g $ h $ x` equivale a `f(g(h(x)))`.

## El operador `#`

`#` **combina dos `ControlPattern`** del mismo tipo, fundiendo sus mapas de control. Su firma:

```haskell
(#) :: Unionable b => Pattern b -> Pattern b -> Pattern b
```

Es **left-biased**: si los dos patrones tienen la misma clave, gana el de la izquierda. Pero en la práctica se usa para **añadir parámetros** que el lado izquierdo no tiene:

```haskell
d1 $ sound "bd sn" # gain "1 0.7" # pan "0 1"
```

Aquí `sound`, `gain` y `pan` producen `ControlPattern`s con claves distintas, así que `#` los une.

**La estructura rítmica viene de la izquierda** (importante con polirritmos):

```haskell
d1 $ sound "drum drum drum drum" # vowel "a o e"   -- 4 eventos, vowel se mapea
d1 $ vowel "a o ~ i" # sound "drum"                -- ahora la estructura la fija vowel
```

## Variantes con dirección: `|+`, `+|`, `|+|`

Para combinar patrones numéricos hay variantes según de dónde viene la estructura:

```haskell
|+   |-   |*   |/    -- estructura del lado izquierdo
+|   -|   *|   /|    -- estructura del lado derecho
|+|  |-|  |*|  |/|   -- estructura mezclada (intersección de eventos)
```

Por ejemplo:

```haskell
d1 $ note "c a f e" # s "superpiano" |- note 12   -- baja una octava
```

## El operador `.` (composición)

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```

Compone dos funciones en una nueva. `(f . g) x ≡ f (g x)`. Es útil para encadenar transformaciones que se aplicarán como un todo:

```haskell
d1 $ sometimes (# room 0.8 . size 0.9) $ s "[bd*4, ~ sn]*2"
d1 $ jux (rev . slow 1.5) $ sound "arpy arpy:1 arpy:2 arpy:3"
```

> Cuidado: el `.` de Haskell **no es** el separador de subsecuencias dentro de la mini-notación.

## Funciones de orden superior

Una **función de orden superior** acepta otra función como argumento. Las más usadas en Tidal:

```haskell
every    :: Pattern Int -> (Pattern a -> Pattern a) -> Pattern a -> Pattern a
jux      :: (ControlPattern -> ControlPattern) -> ControlPattern -> ControlPattern
sometimes:: (Pattern a -> Pattern a) -> Pattern a -> Pattern a
chunk    :: Pattern Int -> (Pattern b -> Pattern b) -> Pattern b -> Pattern b
```

Si la función a aplicar lleva sus propios argumentos, se envuelve en paréntesis:

```haskell
d1 $ every 4 (fast 2)        $ sound "arpy arpy:1 arpy:2 arpy:3"
d1 $ every 3 (# speed 2)     $ sound "arpy*4"
d1 $ jux    (rev)            $ sound "arpy arpy:1 arpy:2 arpy:3"
```

## Tipos clave de Tidal

```haskell
type Time           = Rational
type Arc            = ArcF Time
type Part           = (Arc, Arc)            -- (whole, part)
type Event a        = (Part, a)
data State          = State { arc :: Arc, controls :: ControlMap }
type Query a        = State -> [Event a]
data Pattern a      = Pattern { nature :: Nature, query :: Query a }

data Value          = VS String | VF Double | VI Int
type ControlMap     = Map String Value
type ControlPattern = Pattern ControlMap
```

## Patrones aplicativos: `<$>` y `<*>`

Los patrones son `Functor` y `Applicative`. Eso permite combinarlos con operadores genéricos:

```haskell
(+) <$> run 2 <*> run 3
-- equivale a, y se escribe normalmente como:
run 2 |+| run 3
```

Las variantes `<*` y `*>` deciden de qué lado viene la estructura temporal (igual que `|+` vs `+|`).

## Función propia con `let` y `do`

Para preparar fragmentos antes de tocar:

```haskell
let rotate = slow 4 $ saw

d1 $ s "arpy(5,8)" # pan rotate
```

Para ejecutar varias acciones a la vez se usa `do`:

```haskell
do
  resetCycles
  let rotate = slow 4 $ saw
  d1 $ s "bd*4"
  d2 $ s "arpy(5,8)" # pan rotate
```

Cuidado con la **indentación**: Haskell la usa para delimitar bloques.

## Variantes con apóstrofo: `fit'`, `striate'`

En Haskell el apóstrofo es un carácter válido en nombres y se usa por convención para indicar una **variante** de una función. En Tidal suelen ser versiones más detalladas:

```haskell
d1 $ striate 32 $ s "bev"
d1 $ striate' 32 (1/32) $ s "bev"   -- variante con longitud explícita
```

Continúa con [Transformaciones](07-transformaciones.md).
