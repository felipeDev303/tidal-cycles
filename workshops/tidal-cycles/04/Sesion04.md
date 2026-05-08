# Sesión 4: Composición Algorítmica y Síntesis

En esta sesión usamos Tidal como **instrumento melódico y armónico**, no sólo rítmico. Aprovecharemos los sintetizadores nativos de SuperDirt, las funciones de notación musical y herramientas de estructura para empezar a montar piezas con forma de canción.

> Recuerda iniciar SuperCollider y SuperDirt antes de ejecutar cualquier patrón.

---

## Ejercicio 1: Synths nativos de SuperDirt

SuperDirt incluye varios sintetizadores escritos en SuperCollider que se invocan igual que un sample.

```haskell
-- Algunos disponibles
d1 $ n "0 4 7 12" # sound "superpiano"
d2 $ n "<0 5 7>" # sound "supersaw" # gain 0.7
d3 $ n "0 7 12 7" # sound "superfm"
d4 $ n "<-7 -5 0 5>" # sound "supermandolin"
d5 $ n "0 4 7 9" # sound "superhammond" # legato 0.6
```

> **Ojo:** estos synths viven en SuperCollider y consumen más CPU que un sample. Si oyes glitches, baja la cantidad de eventos por ciclo o el orbit que comparte efectos.

---

## Ejercicio 2: La diferencia entre `n` y `note`

Es la confusión más típica de Tidal. La regla:

- Con un **synth** → `n` y `note` son lo mismo: ambos significan **semitonos sobre C5**.
- Con un **sample** → `n` selecciona el archivo dentro de la carpeta; `note` **transpone** el sample (cambia velocidad y duración).

```haskell
-- Con synth: equivalentes
d1 $ n    "0 4 7" # sound "superpiano"
d1 $ note "0 4 7" # sound "superpiano"

-- Con sample: distintos
d1 $ sound "bd*4" # n "<0 4>" # note "0 12 -7 -12"
-- Esto reproduce bd:0 en ciclos impares y bd:4 en pares,
-- transpuesto cada vez en distinto número de semitonos.
```

---

## Ejercicio 3: Notación musical (nombres de notas)

Tidal acepta nombres de la teoría musical occidental:

```haskell
-- Nombres simples (0 = C5)
d1 $ note "c a f e" # sound "supermandolin"
d1 $ note "0 9 5 4" # sound "supermandolin"  -- equivalente

-- Sostenidos (s) y bemoles (f)
d1 $ note "cs4 ef5" # sound "superpiano"

-- Octavas explícitas
d1 $ note "c4 a3 f6 e5" # sound "superpiano"

-- Transposición global (sube/baja un patrón sin tocar las notas)
d1 $ note "c a f e" # s "superpiano" |+ note 12   -- una octava arriba
d1 $ note "c a f e" # s "superpiano" |- note 24   -- dos octavas abajo
```

> **Truco:** Usa `|+`, `|-`, `|*`, `|/` para combinar valores numéricos sin perder la estructura del lado izquierdo.

---

## Ejercicio 4: Acordes y arpegios

```haskell
-- Acordes: nota + tipo de acorde con apóstrofe
d1 $ note "<c'maj e'min g'maj a'min>" # sound "superpiano"

-- Arpegios desde un acorde
d1 $ arp "up" $ note "c'maj e'min" # sound "superpiano"
d1 $ arp "<up down updown converge>" $ note "c'maj7" # sound "superpiano"

-- Acordes con séptimas y novenas
d1 $ note "<c'maj7 d'min7 g'7 c'maj9>" # sound "superpiano"
```

> **Mini-teoría:** `c'maj` es Do mayor (C, E, G). `d'min7` es Re menor 7 (D, F, A, C). Cualquier acorde se construye desde una nota raíz y un sufijo (`maj`, `min`, `maj7`, `min7`, `dim`, `aug`, `sus2`, `sus4`...).

---

## Ejercicio 5: Apilar patrones con `stack` y mezclar parámetros

`stack` reproduce varios patrones simultáneos **dentro de un mismo `dN`**, útil para concentrar ideas y compartir efectos.

```haskell
d1 $ stack
  [ sound "bd(3,8)" # gain 0.9
  , note "c2 ~ ~ c2 ~ ~ ef2 ~" # s "supersaw" # cutoff 800 # resonance 0.3
  , n (run 8) # s "supermandolin" # legato 0.4 # gain 0.6
  ]
```

```haskell
-- Equivalente con varios canales
d1 $ sound "bd(3,8)" # gain 0.9
d2 $ note "c2 ~ ~ c2 ~ ~ ef2 ~" # s "supersaw" # cutoff 800 # resonance 0.3
d3 $ n (run 8) # s "supermandolin" # legato 0.4 # gain 0.6
```

> **Cuándo usar uno u otro:** `dN` separados son más cómodos para mute/solo y para compartir efectos por orbit. `stack` es genial cuando un mismo "instrumento" se compone de varias capas que siempre van juntas.

---

## Ejercicio 6: Bloques `let` y `do` para preparar material

Si vas a tocar un set, conviene **definir tus materiales** antes de tocar.

```haskell
-- Definir piezas reutilizables
let drumsA  = sound "bd(3,8) [~ cp]"
    melodyA = note "<c'maj e'min g'maj>" # s "superpiano"
    rotate  = slow 4 $ saw

d1 $ drumsA
d2 $ melodyA # pan rotate
```

```haskell
-- Lanzar varias acciones a la vez con do
do
  resetCycles
  d1 $ s "bd*4"
  d2 $ s "arpy(5,8)" # pan (slow 4 saw)
  d3 $ note "<c'maj a'min f'maj g'7>" # s "superpiano" # gain 0.6
```

> **Cuidado con la indentación:** Haskell delimita bloques por sangría. Si un `do` falla, casi siempre es porque las líneas no están alineadas a la misma columna.

---

## Ejercicio 7: LFOs continuos y buses de control

Las funciones `sine`, `cosine`, `saw`, `tri`, `square` y `perlin` son **patrones analógicos** que devuelven valores entre 0 y 1. Sirven para automatizar parámetros suavemente.

```haskell
-- Paneo en onda lenta
d1 $ s "bd*8" # pan (slow 4 sine)

-- Cutoff con envolvente de saw, escalado a Hz
d1 $ s "moog*16"
   # n "<0 1 2>"
   # legato 1
   # cutoff (range 200 2400 saw)
   # resonance 0.2
```

Cuando un patrón tiene **pocos eventos largos**, el LFO sólo dispara un valor por evento (no se mueve). Para suavizar usa **buses de control** y `segment`:

```haskell
d1 $ s "moog" # n "<0 1 2>"
   # legato 1
   # cutoffbus 1 (segment 32 $ range 200 2400 saw)   -- 32 muestras del LFO por ciclo
   # resonance 0.2
```

> **Concepto clave:** `segment N` muestrea el LFO `N` veces por ciclo. Cuanto más alto `N`, más suave el barrido — y más mensajes OSC al servidor. Encuentra el equilibrio.

---

## Ejercicio 8: Estructura tipo "canción" con `seqP` y `ur`

`seqP` permite secuenciar patrones por **rangos de ciclos**. Es lo más cercano a una "canción" tradicional dentro de Tidal.

```haskell
do
  resetCycles
  d1 $ seqP
    [ (0,  16, sound "bd bd*2")
    , (8,  24, sound "hh*2 [sn cp] cp future*4")
    , (16, 32, note "<c'maj e'min g'maj a'min>" # s "superpiano")
    ]
```

```haskell
-- Variante más declarativa con ur (patrones nombrados)
let pat1 = sound "bd*4"
    pat2 = sound "cp(3,8)"
    pat3 = note "c'maj e'min g'maj" # s "superpiano"

d1 $ ur 8 "<a b a c>"
       [ ("a", pat1)
       , ("b", pat2)
       , ("c", pat3)
       ]
       []
```

> **Caveat:** `seqP` se ata al **contador global de ciclos**. Si lo evalúas con el ciclo ya muy avanzado, puede no entrar. Acompáñalo siempre con `resetCycles` dentro del mismo `do`.

---

## Ejercicio 9: Transiciones suaves entre versiones

Cuando cambias un patrón en mitad del set, el corte puede ser brusco. Tidal trae transiciones para suavizarlo:

```haskell
-- xfade: crossfade clásico (1 ciclo)
xfade 1 $ sound "bd sn cp hh"

-- jumpIn: entra progresivamente a lo largo de N ciclos
jumpIn 4 1 $ sound "bd(5,8)"

-- anticipate: anticipación con pequeño desfase
anticipate 1 $ note "c'maj e'min g'maj" # s "superpiano"

-- smooth: interpola suavemente entre valores numéricos
d1 $ s "bass*8" # speed (smooth "1 2 0.5")
```

---

## Reto final de la sesión

Compón un fragmento de **24 ciclos** con tres secciones:

1. **Intro (8 ciclos):** Sólo un drone armónico con `superpiano` o `supersaw` y un `chop` de un sample largo. Filtro abriéndose con `cutoffbus + perlin`.
2. **Cuerpo (8 ciclos):** Entra la batería con un patrón euclidiano + un canal de bajo (`note "c2 ~ ~ ef2"` con `supersaw`). Aplica `every 4 (jux rev)` a uno de los canales.
3. **Outro (8 ciclos):** Aleja todo: baja el `gain`, sube el `room`/`size`, deja sólo el drone con `degradeBy 0.6`.

Usa `seqP` o `ur` para automatizar la entrada/salida.

> **Pregunta para la clase:** ¿Qué pasa si en lugar de `seqP` controlas los cambios *manualmente* reescribiendo `d1`, `d2`, `d3` mientras tocas? Esa es la diferencia entre **composición programada** y **live coding puro**. Tidal te permite ambas; la mayoría de algoraves se hacen al estilo puro.
