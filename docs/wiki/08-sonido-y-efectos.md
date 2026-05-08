# 8. Sonido, samples y efectos

## Bibliotecas de samples

Por defecto SuperDirt incluye la carpeta **Dirt-Samples** (encontrable en SuperCollider: *File → Open user support directory → downloaded-quarks → Dirt-Samples*). Cada subcarpeta corresponde a un nombre que puedes usar con `sound`/`s`. Algunas comunes:

```
flick sid can metal future gabba sn mouth co gretsch mt arp h cp
cr newnotes bass hc tabla bass0 hh bass1 bass2 oc bass3 ho odx
diphone2 house off ht tink perc bd industrial pluck trump printshort
jazz voodoo birds3 procshort blip drum jvbass psr wobble drumtraks koy
rave bottle kurt latibro rm sax lighter lt arpy feel less stab ul
```

Para añadir tus propias carpetas, consulta la guía de SuperDirt; conviene numerar los nombres de archivo (`00bd.wav`, `01sn.wav`) porque el orden importa.

## Selección de muestras

Equivalentes:

```haskell
d1 $ sound "drum:1"
d1 $ sound "drum" # n 1
d1 $ s     "drum" # n 1     -- s es alias de sound
```

`n` indexa por orden alfabético dentro de la carpeta; `:N` hace lo mismo en mini-notación.

## Volumen, paneo y pitch

```haskell
d1 $ sound "bd hh sn:1 hh sn:1 hh" # gain "1 0.7 0.5"
d1 $ sound "numbers:1 numbers:2 numbers:3 numbers:4"
   # pan "0 0.5 1"
d1 $ sound "numbers:1 .. numbers:4" # speed "1 1.5 2 0.5"
d1 $ up    "0 ~ 12 24" # sound "jungbass:6"   -- en semitonos
```

`speed` reproduce más rápido o más lento (afecta pitch); `up` transpone en semitonos.

## Distorsión

```haskell
d1 $ sound "kurt:4 kurt:4" # shape "0 0.78" # gain "0.7"
```

`shape` aumenta el volumen significativamente: combínalo con `gain` para compensar.

## Delay

```haskell
d1 $ sound "cp"
   # delay 0.8
   # delaytime (1/6)
   # delayfeedback 0.6
   # lock 1
```

`lock 1` indica que `delaytime` está expresado en **ciclos** y no en segundos. Todos estos parámetros aceptan patrones:

```haskell
d1 $ sound "industrial:3*4"
   # delay         "<0 0.4 0.8>"
   # delaytime     "0.2 0.05"
   # delayfeedback "<0.5 0.9>"
   # lock 1
```

## Reverb

```haskell
d1 $ sound "[~ sn]*2" # dry 0.4 # room 0.6 # size 0.8
```

## Filtros

```haskell
-- Pasa-bajos
d1 $ sound "tabla*4" # n "0 1 2 3" # cutoff 400  # resonance 0.2

-- Pasa-altos
d1 $ sound "tabla*4" # n "0 1 2 3" # hcutoff 600 # hresonance 0.2

-- Filtro de DJ (0..1: <0.5 LP, >0.5 HP)
d1 $ sound "..." # djf "0.3 0.7"
```

`cutoff`/`hcutoff` esperan frecuencia en Hz. La resonancia entre 0 y 1; valores altos pueden ser **muy ruidosos**.

## Filtro de vocal

```haskell
d1 $ sound "drum drum drum drum" # vowel "a o e i"
d1 $ sound "drum drum drum drum" # vowel "a o p p"   -- p para silenciar el efecto
```

## Manipulación de samples largos

Los samples largos siguen sonando aunque pares el patrón. Soluciones:

```haskell
d1 $ sound "bev" # cut 1     -- corta cuando otro evento del mismo grupo dispara
d1 $ sound "bev ~ bev ~" # legato 1   -- duración fija
```

`cut N` agrupa: dos patrones con `cut 1` se cortan entre sí.

### Granular y trozado

```haskell
d1 $ chop 32        $ sound "bev"
d1 $ slow 4 $ chop 4 $ sound "arpy:1 arpy:2 arpy:3 arpy:4"
d1 $ slow 4 $ striate 4 $ sound "arpy:1 arpy:2 arpy:3 arpy:4"
d1 $ randslice 32  $ sound "bev"
d1 $ loopAt 8      $ sound "bev"
```

- `chop`: divide en N partes y las toca seguidas.
- `striate`: divide y entrelaza las N partes de cada sample.
- `randslice`: elige un trozo aleatorio cada ciclo.
- `loopAt`: ajusta el sample a N ciclos.

Combinaciones poderosas:

```haskell
d1 $ loopAt "<8 4 16>" $ chop 64 $ sound "bev*4" # cut 1
d1 $ rev $ loopAt 8 $ chop 128 $ sound "bev"
```

Otras: `gap`, `striate'`, `off`, `stut`.

## Patrones de efectos

Recordatorio: los parámetros son patrones también, así que puedes aplicarles transformaciones:

```haskell
d1 $ sound "jvbass [jvbass jvbass] jvbass ~" # iter 3 (note "1 [3 5] 7")
```

Continúa con [Aleatoriedad](09-aleatoriedad.md).
