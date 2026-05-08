# 11. Performance live: organización del código

Tocar Tidal en vivo no es solo escribir patrones, sino **organizar el código** para poder modificarlo de forma fluida bajo presión.

## Comentarios para alternar

`--` comenta una línea. Es un recurso muy usado en escena para activar/desactivar transformaciones rápidamente:

```haskell
d1
--  $ fast 2
  $ jux rev
  $ s "hh*8"
```

## Atajos de control

```haskell
hush          -- detiene todos los patrones
solo 2        -- silencia todos menos d2
unsolo 2
mute 1        -- silencia d1
unmute 1
unmuteAll
d3 silence    -- detiene únicamente d3
setcps (-1)   -- pausa cambiando el reloj a negativo
setcps 0.6    -- reanuda
```

El plugin de Pulsar añade atajos como `Ctrl+1..9` para mute/unmute por canal y `Ctrl+0` para `unmuteAll`. `Ctrl+.` ejecuta `hush`.

## Función `panic`

Conviene definir un panic más agresivo que `hush`:

```haskell
let panic = do hush
               once $ s "superpanic"
```

Al evaluarla quedará disponible como `panic`. Hay que reevaluarla cada vez que reinicies el archivo (o ponerla en tu `BootTidal.hs` personal).

## `once` y `asap`

`once` envía un patrón **una sola vez**, sin loop. Útil para drones largos, intros o como "drum pad":

```haskell
once $ s "superpanic"
once $ s "bev"
```

`asap` es similar pero sin esperar al siguiente borde de ciclo.

## `let` para preparar material

```haskell
let rotate    = slow 4 $ saw
    melodyA   = note "c d ef g"  # s "superpiano"
    drumsA    = s "bd(3,8) [~ sn] cp ~"
```

Después puedes recombinar:

```haskell
d1 $ drumsA
d2 $ melodyA # pan rotate
```

## `do` para acciones agrupadas

```haskell
do
  resetCycles
  d1 $ s "bd*4"
  d2 $ s "arpy(5,8)" # pan (slow 4 $ saw)
```

Todo lo que esté indentado al mismo nivel se ejecuta como un bloque.

## `seqP` y `seqPLoop`

Permiten **secuenciar patrones por ciclos**, útil para estructuras de canción:

```haskell
do
  resetCycles
  d1 $ seqP
    [ (0,  16, sound "bd bd*2")
    , (8,  24, sound "hh*2 [sn cp] cp future*4")
    , (8,  32, sound (samples "arpy*8" (run 16)))
    ]
```

Limitación importante: `seqP` se ata al **contador global de ciclos**, así que si lo evalúas tarde, el patrón puede no entrar. Acompáñalo con `resetCycles`.

`seqPLoop` repite la secuencia indefinidamente.

## `ur`: patrones de patrones

Permite definir una "estructura" de canción usando nombres de patrones:

```haskell
let pat1 = s "bd*4"
    pat2 = s "cp(3,8)"

d1 $ ur 8 "<a b a c>"
       [ ("a", pat1)
       , ("b", pat2)
       , ("c", s "arpy(5,8) # speed 2")
       ]
       []
```

## Optimización del rendimiento

SuperCollider tiene límites. Si el indicador de uso del servidor pasa de 100%, oirás *glitches* o silencios.

- **Acorta o cambia samples** muy largos.
- Usa `cut` para que un sample corte al anterior.
- Cuidado con `striate`/`chop` agresivos: generan muchos eventos por ciclo.
- **Comparte efectos por `orbit`**: dos canales con el mismo `# orbit 0` comparten su instancia de delay/reverb.

```haskell
d1 $ s "bd*4" # orbit 0 # delay 0.5 # delaytime 0.125 # delayfeedback 0.6
d2 $ s "cp"   # orbit 0   -- comparte el delay de arriba
```

## Backups y archivos `.tidal`

Aunque toques en vivo, es buena idea guardar tus archivos `.tidal` con snippets reusables, así como mantener un `BootTidal.hs` propio en la carpeta de proyecto con tus helpers, definiciones de OSC y atajos.

Continúa con [OSC, MIDI y multicanal](12-osc-midi.md).
