# 7. Transformaciones de patrones

Las transformaciones son funciones que toman un patrón y devuelven otro modificado. Se aplican con `$`.

## Tiempo: `slow`, `fast`, `hurry`, `density`

```haskell
d1 $ slow 2 $ sound "arpy arpy:1 arpy:2 arpy:3"   -- el patrón ocupa 2 ciclos
d1 $ fast 2 $ sound "arpy arpy:1 arpy:2 arpy:3"   -- 2 repeticiones por ciclo
d1 $ fast 0.5 $ sound "..."   -- equivalente a slow 2
```

`density` es alias de `fast`. `hurry` es como `fast` pero **además** sube el `speed` (pitch):

```haskell
d1 $ hurry 2 $ sound "arpy arpy arpy:1 arpy:2"
```

Los argumentos pueden ser, a su vez, patrones:

```haskell
d1 $ fast "2 3 4" $ sound "bd sn arpy"
```

## Reordenar: `rev`, `palindrome`, `iter`

```haskell
d1 $ rev        $ sound "arpy arpy:1 arpy:2 arpy:3"  -- al revés
d1 $ palindrome $ sound "arpy arpy:1 arpy:2 arpy:3"  -- ida y vuelta
d1 $ iter 4     $ sound "arpy arpy:1 arpy:2 arpy:3"  -- empieza en otro punto cada ciclo
```

## Desplazamiento: `<~`, `~>`

Empujan el patrón en el tiempo:

```haskell
d1 $ 0.25 <~ $ sound "bd sn cp hh"   -- adelanta 1/4 de ciclo
d1 $ 0.25 ~> $ sound "bd sn cp hh"   -- atrasa 1/4 de ciclo
```

## Aplicar transformaciones cíclicamente: `every`, `whenmod`

```haskell
d1 $ every 4 (fast 2) $ sound "arpy arpy:1 arpy:2 arpy:3"
d1 $ every 3 (# speed 2) $ sound "arpy*4"
d1 $ every 8 (0.25 <~) $ sound "bd hh:8*2 bd hh:8"
```

## Estéreo creativo: `jux`

`jux` (juxtapose) aplica una función **solo al canal derecho**, dejando el izquierdo intacto:

```haskell
d1 $ jux rev $ sound "arpy arpy:1 arpy:2 arpy:3"
d1 $ jux (hurry 2) $ sound "arpy arpy arpy:1 arpy:2"
```

Variante: `juxcut` evita que las dos voces se superpongan acumulando.

## Trozos: `chunk`

Aplica una función a un fragmento distinto del patrón en cada ciclo:

```haskell
d1 $ chunk 4 (hurry 2)   $ sound "arpy arpy:1 arpy:2 arpy:3"
d1 $ chunk 4 (# speed 2) $ sound "alphabet:0 alphabet:1 alphabet:2 alphabet:3"
```

## Combinar transformaciones

Con `.` se encadenan en una sola función:

```haskell
d1 $ jux (rev . slow 1.5) $ sound "arpy arpy:1 arpy:2 arpy:3"
d1 $ sometimes (# room 0.8 . size 0.9) $ s "[bd*4, ~ sn]*2"
```

## LFOs con osciladores continuos

Funciones como `sine`, `cosine`, `saw`, `tri`, `square` y `perlin` son **patrones analógicos** que devuelven valores entre 0 y 1:

```haskell
d1 $ s "bd*8" # pan (slow 4 $ sine)
d1 $ s "moog*16" # n "<0 1 2>" # legato 1
   # cutoff (range 200 2400 $ saw) # resonance 0.2
```

`range` reescala la onda al rango deseado.

Para suavizar el LFO sobre eventos largos, usa **buses de control** (`cutoffbus`, `panbus`...) con `segment`:

```haskell
d1 $ s "moog" # n "<0 1 2>" # legato 1
   # cutoffbus 1 (segment 32 $ range 200 2400 $ saw)
   # resonance 0.2
```

`segment 32` muestrea el LFO 32 veces por ciclo para hacer el barrido suave.

## Transiciones entre versiones

Para no cortar abruptamente el cambio de un patrón, hay funciones de transición:

```haskell
xfade 1 $ sound "bd sn cp hh"          -- crossfade
jumpIn 4 1 $ sound "..."                -- entra en 4 ciclos
anticipate 1 $ sound "..."              -- anticipación
```

`smooth` interpola valores numéricos suavemente entre eventos:

```haskell
d1 $ s "bass*8" # speed (smooth "1 2 0.5")
```

## Funciones generativas

- `markovPat`: cadenas de Markov sobre estados.
- Funciones tipo Lindenmayer / L-System para generar secuencias por reglas de reescritura.

## Exploración

Una sesión típica de live coding consiste en empaquetar varias transformaciones en cascada y modificarlas una a una:

```haskell
d1 $ slow 4
   $ spaceOut (map (1/) [1, 1.2 .. 10])
   $ sometimesBy 0.66 rev
   $ rarely (juxcut (# speed (choose [0.33, 0.5, 0.66, 0.75, 1.5, 2])))
   $ sound "bd*4"
   # n   (choose [1, 3, 5, 7])
   # pan (slow 4 $ sine)
   # orbit 0
```

Continúa con [Sonido y efectos](08-sonido-y-efectos.md).
