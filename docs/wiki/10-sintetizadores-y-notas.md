# 10. Sintetizadores, notas y armonía

Además de samples, SuperDirt incluye sintetizadores nativos de SuperCollider, llamados **synths**. Algunos: `superpiano`, `supersaw`, `superfm`, `supersquare`, `supermandolin`, `superhammond`, `supergong`, `superhoover`...

## Tocar un synth

```haskell
d1 $ n "0 4 7" # sound "superpiano"
```

## `n` vs `note`

Cuando se trata de **synths**, `n` y `note` son equivalentes y representan **semitonos** desde C5. Cuando se trata de **samples**:

- `n` selecciona el N-ésimo archivo de la carpeta.
- `note` **transpone** el sample (cambiando velocidad y duración) en semitonos.

```haskell
-- synth: equivalentes
d1 $ n    "0 4 7" # sound "superpiano"
d1 $ note "0 4 7" # sound "superpiano"

-- sample: distintos
d1 $ sound "bd*4" # n "<0 4>" # note "0 12 -7 -12"
```

## Notación musical

Puedes usar nombres `c d e f g a b` con sostenido (`s`) y bemol (`f`). El cero corresponde a **C5**:

```haskell
d1 $ note "c a f e"     # s "supermandolin"
d1 $ note "0 9 5 4"     # s "supermandolin"   -- equivalente
d1 $ note "c4 a3 f6 e5" # s "supermandolin"
d1 $ note "cs4 ef5"     # s "superpiano"      -- C# y Eb
```

Para mover de octava:

```haskell
d1 $ note "c a f e" # s "superpiano" |- note 24   -- 2 octavas abajo
d1 $ note "c a f e" # s "superpiano" |+ note 12   -- 1 octava arriba
```

## Arpegios y acordes

Hay funciones específicas (consultar la documentación oficial de "Harmony" en tidalcycles.org):

```haskell
d1 $ note (arpeggiate "<c'maj e'min g'maj>") # s "superpiano"
d1 $ chord "<c'maj7 d'min7 g'7 c'maj7>" # s "supersaw"
```

`arp` y `up`/`down` cambian el patrón del arpegio:

```haskell
d1 $ arp "up" $ note "c'maj e'min" # s "superpiano"
d1 $ arp "<up down updown converge>" $ note "c'maj7" # s "superpiano"
```

## Parámetros típicos de synths

```haskell
# attack 0.01
# release 0.5
# legato 1            -- duración relativa al ciclo del evento
# voice 2             -- variantes timbricas (depende del synth)
# detune 0.2
# octave 4
```

## Combinar synth y sample

```haskell
d2 $ stack
  [ s "bd(3,8)" # gain 0.9
  , note "c2 ~ ~ c2 ~ ~ ef2 ~" # s "supersaw" # cutoff 800 # resonance 0.3
  , n (run 8) # s "supermandolin" # legato 0.4
  ]
```

`stack` reproduce varios patrones a la vez **en un solo orbit**, útil para compactar mucha música en una sola línea `dN`.

Continúa con [Performance](11-performance.md).
