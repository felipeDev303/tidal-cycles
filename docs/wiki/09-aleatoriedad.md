# 9. Aleatoriedad y variación

Tidal usa **aleatoriedad determinista** basada en el tiempo: el mismo ciclo produce siempre los mismos valores "aleatorios". Esto permite improvisar sin sorpresas catastróficas.

## Generadores de números

```haskell
rand          -- Pattern Double entre 0 y 1
irand n       -- Pattern Int entre 0 y n-1
perlin        -- ruido suave (analógico) entre 0 y 1
```

Ejemplos:

```haskell
d1 $ sound "tink*16" # gain rand
d1 $ sound "arpy(3,8)" # n (irand 16)
d1 $ s "moog*8" # cutoff (range 200 4000 perlin) # resonance 0.3
```

## Probabilidades de aplicación

Todas siguen el patrón "aplica esta transformación con probabilidad X":

```haskell
sometimes  f p   -- 50%
often      f p   -- 75%
rarely     f p   -- 25%
almostNever f p  -- 10%
almostAlways f p -- 90%
sometimesBy 0.66 f p   -- explícita
```

Ejemplo:

```haskell
d1 $ sometimes (# speed "2") $ sound "drum*8"
d1 $ rarely    (juxcut rev)  $ sound "bd(5,8) sn"
```

Variantes con sufijo:

```haskell
someCycles  f p    -- aplica a algunos ciclos enteros
someCyclesBy 0.5 f p
```

## Eliminación aleatoria de eventos

```haskell
d1 $ degrade           $ sound "tink*16"   -- 50%
d1 $ degradeBy 0.2     $ sound "tink*16"   -- elimina 20%
d1 $ sound "bd sn:2? bd sn?"               -- ? por evento, en mini-notación
```

## Selección aleatoria de elementos

```haskell
d1 $ s "bd*4" # n (choose [0, 3, 5, 7])      -- elige uno cada evento
d1 $ s "bd*4" # speed (choose [0.5, 1, 2])
d1 $ s "[bd|cp|sn:2]*4"                       -- en mini-notación con |
```

`randcat` elige un patrón completo al azar entre varios cada ciclo:

```haskell
d1 $ randcat [ sound "bd*4"
             , sound "cp(3,8)"
             , sound "sn:2 ~ sn:2 ~"
             ]
```

`shuffle` y `scramble` reordenan eventos:

```haskell
d1 $ shuffle 4 $ s "arpy*4"     -- mezcla 4 trozos al azar
d1 $ scramble 4 $ s "arpy*4"
```

## Perlin noise

`perlin` es ruido **suave** (no hay saltos abruptos), ideal para parámetros analógicos como filtros o paneo:

```haskell
d1 $ s "moog*16" # cutoff (range 100 5000 (slow 8 perlin))
                 # resonance 0.4
```

## Semillas y reproducibilidad

Si quieres congelar la aleatoriedad puedes usar `rotR`/`rotL` sobre el patrón aleatorio o capturar el estado en un `let`. En general la aleatoriedad de Tidal es estable mientras no cambies de ciclo.

Continúa con [Sintetizadores y notas](10-sintetizadores-y-notas.md).
