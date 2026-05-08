# 5. Mini-notación de patrones

La **mini-notación** es la sintaxis tipo string que escribes entre comillas en Tidal. Tiene su propio parser y permite describir patrones complejos en muy pocos caracteres.

```haskell
d1 $ sound "bd ~ sn:3 [bd cp]*2"
```

## Secuencia básica

Cada token, separado por espacios, es un evento que se reparte uniformemente dentro del ciclo:

```haskell
d1 $ sound "bd hh sn hh"           -- 4 eventos por ciclo
d1 $ sound "bd bd hh bd sn bd hh bd"  -- 8 eventos: el doble de rápido
```

## Silencio: `~`

```haskell
d1 $ sound "bd ~ sn:3 bd sn:5 ~ bd:2 sn:2"
```

## Subsecuencias: `[ ]`

Los corchetes agrupan un sub-patrón en **un solo paso**:

```haskell
d1 $ sound "bd [bd cp] bd bd"           -- el segundo tiempo = bd y cp en mitad de tiempo
d1 $ sound "[[bd bd] bd sn:5] [bd sn:3]"  -- pueden anidarse
```

Esto permite **firmas de tiempo flexibles**.

## Repetición y división: `*` y `/`

```haskell
d1 $ sound "bd sd*2"        -- "sd" se repite 2 veces dentro de su paso
d1 $ sound "bd [sd cp]*2"   -- también funciona con grupos
d1 $ sound "bd sn/2"        -- "sn" tarda 2 pasos (suena cada 2 ciclos en su posición)
```

## Selección de sample: `:`

Cada nombre como `bd` corresponde a una **carpeta** de samples en Dirt-Samples. `:N` elige el N-ésimo (empezando en 0):

```haskell
d1 $ sound "bd:1"           -- segundo sample de la carpeta bd
d1 $ sound "bd:2(5,8)"      -- combinable con todo lo demás
```

Equivalente con `n`:

```haskell
d1 $ sound "bd" # n 1
d1 $ sound "drum" # n "0 1 2 3"
```

## Alternancia entre ciclos: `< >`

Los signos de mayor/menor menor alternan elementos **a lo largo de ciclos** sucesivos, no dentro del mismo ciclo:

```haskell
d1 $ sound "bd <sd cp arpy>"
-- ciclo 1: bd sd
-- ciclo 2: bd cp
-- ciclo 3: bd arpy
```

## Aleatoriedad inline

```haskell
d1 $ sound "[bd:0|bd:1]"    -- elige uno de los dos al azar
d1 $ sound "[sn|cp]"
d1 $ sound "hh*16?"          -- 50% de chance de quitar cada evento
d1 $ sound "bd sn:2? bd sn?" -- "?" tras un evento lo degrada al 50%
```

## Polirritmia y polimetría: `[ , ]` vs `{ , }`

- **Corchetes con coma**: ambos sub-patrones se ajustan al mismo ciclo (**polirritmo**: comparten longitud, distinta cantidad de pasos):

```haskell
d1 $ sound "[bd bd, can can:2 can:3 can:4 can:2]"
```

- **Llaves con coma**: el sub-patrón de la izquierda fija el pulso, los demás *flotan* sobre él (**polimetría**):

```haskell
d1 $ sound "{bd sn, can:2 can:3 can:1, arpy arpy:1 arpy:2 arpy:3 arpy:5}"
```

## Replicación: `!`

Repite el evento **manteniendo su duración**, en contraste con `*` que comprime:

```haskell
d1 $ sound "bd!3 sn"   -- bd bd bd sn (4 eventos)
d1 $ sound "bd*3 sn"   -- 3 bd en la primera mitad, sn en la segunda
```

## Elongación: `_` y `@`

Alargan el evento previo:

```haskell
d1 $ sound "bd bd _ _ _ _ arpy _"
d1 $ sound "bd bd@5 arpy _"     -- bd, luego bd que dura 5 pasos
```

## Ritmos euclidianos: `( , )` y `( , , )`

Distribuyen N pulsos uniformemente sobre M pasos (algoritmo de Bjorklund):

```haskell
d1 $ sound "bd(3,8)"      -- 3 bombos repartidos en 8 pasos
d1 $ sound "bd(5,8,2)"    -- como arriba pero rotado 2 pasos
d1 $ sound "bd(3,8) sn(5,8)"
```

Los ritmos euclidianos generan figuras clásicas (tresillo cubano, son, bossa, etc.) con poquísimos parámetros.

## Rangos: `..`

Generan secuencias numéricas:

```haskell
d1 $ n "0 .. 7" # sound "arpy"
```

## Resumen rápido

| Símbolo | Función |
|---|---|
| `~` | Silencio |
| `[ ]` | Sub-secuencia (un paso) |
| `*` | Repetir comprimiendo |
| `/` | Estirar (se reparte entre ciclos) |
| `:` | Elegir sample dentro de la carpeta |
| `< >` | Alternar entre ciclos |
| `\|` | Elegir uno al azar (dentro de `[ ]`) |
| `,` | Capas simultáneas (con `[ ]` o `{ }`) |
| `[ , ]` | Polirritmo |
| `{ , }` | Polimetría |
| `!` | Replicar manteniendo duración |
| `_` `@` | Elongar evento previo |
| `?` | Degradar al 50% |
| `( , )` | Ritmo euclidiano |
| `..` | Rango numérico |

Continúa con [Haskell, tipos y operadores](06-haskell-y-operadores.md).
