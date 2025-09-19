# TidalCycles Cheat Sheet

## Basics

### Reproducir sonidos

```haskell
d1 $ sound "bd"
-- o
d1 $ s "bd"
```

### Diferentes samples

```haskell
d1 $ sound "bd:1"
-- o
d1 $ sound "bd" # n "1"
-- o
d1 $ n "0 2" # sound "arpy"
```

### Ejecutar código

- **Una línea**: `Shift+Enter`
- **Múltiples líneas**: `Ctrl+Enter`

### Patrones

```haskell
d1 $ sound "bd sd"          -- Secuencia básica
d1 $ sound "bd*4"           -- Repetición
d1 $ sound "bd/4"           -- Espaciado
d1 $ sound "[bd hh] sd"     -- Agrupación (anidado)
d1 $ sound "bd . hh . sd"   -- Notación con puntos (más fácil de leer)
d1 $ sound "[bd bd, hh sd hh]" -- Capas (simultáneas)
d1 $ sound "bd<arpy:0 arpy:3>" -- Alternancia por ciclo
```

### Silenciar

```haskell
d1 $ silence
solo $ d1 $ sound "bd"
mapM ($ silence) [d1, d2, d3]
hush  -- silencia todo
```

### Estructuras rítmicas

```haskell
d1 $ sound "[bd sd]*2 cp"   -- Grupos - cada grupo es como un pequeño bucle
d1 $ sound "{bd hh cp}%4"   -- Polirritmia - distribuye eventos uniformemente
d1 $ sound "bd(5,8)"        -- Bjorklund/Euclidiano - 5 hits distribuidos en 8 pasos
d1 $ sound "bd(5,8,1)"      -- Con desplazamiento
d1 $ sound "bd([5,3]/2,8)"  -- Parámetros variables
d1 $ e 5 8 $ sound "bd"     -- Forma abreviada
```

### Tempo

```haskell
setcps 1
setcps (140/60/4)  -- BPM a CPS
```

## Transformaciones de patrones

### Determinísticas

```haskell
d1 $ brak $ sound "bd sd"   -- Comprime y desplaza
d1 $ fast 2 $ sound "bd sd" -- Acelera (slow hace lo contrario)
d1 $ jux (rev) $ sound "bd sd cp hh" -- Aplica función al canal derecho
d1 $ juxBy 0.5 (rev) $ sound "bd sd cp hh" -- Control de intensidad
d1 $ linger 0.25 $ sound "bd sd cp hh" -- Repite el primer 1/4 del ciclo
d1 $ (0.25 <~) $ sound "bd sd cp hh" -- Rotación rítmica
d1 $ rev $ sound "bd sd cp hh" -- Invertir
d1 $ trunc 0.75 $ sound "bd sd cp hh" -- Reproduce solo parte del ciclo
d1 $ zoom (0.25, 0.75) $ sound "bd sd cp hh" -- Enfoca una sección
```

### Estocásticas

```haskell
d1 $ degradeBy 0.9 $ sound "bd*16" -- Elimina eventos aleatoriamente (90%)
d1 $ scramble 2 $ sound "bd sd cp hh" -- Aleatoriza con reemplazo
d1 $ shuffle 2 $ sound "bd sd cp hh" -- Aleatoriza sin reemplazo
```

### Procesamiento de samples

```haskell
d1 $ loopAt 4 $ sound "breaks125" -- Ajusta el sample a 4 ciclos
d1 $ chop 16 $ sound "breaks125" -- Granula cada sample en orden
d1 $ striate 16 $ sound "breaks125" -- Granula entrelazando todos los samples
d1 $ striate' 32 (1/16) $ sound "breaks125" -- Con control de densidad
d1 $ striateL' 3 0.125 4 $ sound "breaks125" -- Bucles de fragmentos
d1 $ stut 4 0.5 0.2 $ sound "bd" -- Delay (ecos, nivel, tiempo)
d1 $ stut' 2 (1/3) (# vowel "a e i o u%2") $ sound "bd" -- Stut generalizado
```

### Condicionales

```haskell
d1 $ someCyclesBy 0.25 (fast 2) $ sound "bd sd"
d1 $ foldEvery [3,4] (fast 2) $ sound "bd sd"
d1 $ ifp ((== 0) . (`mod` 2)) (striate 4) (# coarse "24 48") $ sound "bd sd"
d1 $ every 3 (fast 2) $ sound "bd sd"
d1 $ every' 3 1 (fast 2) $ sound "bd sd"
d1 $ sometimesBy 0.25 (fast 2) $ sound "bd sd"
d1 $ whenmod 4 2 (fast 2) $ sound "bd sd"
d1 $ within (0, 0.5) (fast 2) $ sound "bd sd cp hh"
```

## Composiciones

```haskell
d1 $ cat [sound "bd*2", sound "arpy jvbass*2"] -- Concatena manteniendo duración
d1 $ fastcat [sound "bd*2", sound "arpy jvbass*2"] -- Ajusta a un ciclo
d1 $ randcat [sound "bd*2", sound "arpy jvbass*2"] -- Aleatorio
d1 $ stack [
  sound "bd bd*2",
  sound "hh*2 [sn cp] cp future*4"
] -- Superpone patrones
d1 $ weave 4 (pan sine) [
  sound "[jazz:0 hh jazz:0 hh, sn]",
  sound "casio casio:1"
] -- Aplica patrones con desplazamiento
```

## Transiciones

```haskell
t1 (anticipateIn 4) $ sound "jvbass(5,8)"
xfade 1 $ sound "bd sd"
```

## Parámetros y efectos

```haskell
d1 $ sound "bd" # sustain 0.5 # speed 2
d1 $ sound "bd" # begin 0.2 # end 0.6 # loop 4
d1 $ sound "bd" # pan (sine) -- Valores entre 0 y 1

-- Envolvente
d1 $ sound "bd" # attack 0.1 # hold 0.2 # release 0.5

-- Filtros
d1 $ sound "bd" # hpf 300 # hresonance 0.2
d1 $ sound "bd" # lpf 1000 # resonance 0.3
d1 $ sound "bd" # bpf 800 # bandq 0.8

-- Efectos
d1 $ sound "bd" # delay 0.8 # delaytime 0.25 # delayfeedback 0.7
d1 $ sound "bd" # room 0.8 # reverb 0.5
d1 $ sound "bd" # tremolodepth 0.8 # tremolorate 8
d1 $ sound "bd" # phaserdepth 0.6 # phaserrate 0.8

-- Otros
d1 $ sound "bd" # coarse 4
d1 $ sound "bd" # crush 8
d1 $ sound "bd" # cut 1 -- Para samples que se cortan entre sí
d1 $ sound "arpy" # accelerate 1
d1 $ sound "bd" # shape 0.8
d1 $ sound "bd" # vowel "a"
```

## Funciones útiles

```haskell
d1 $ sound "arpy" # note (choose [0, 2, 3, 5, 7])
d1 $ sound "amencutup*8" # n (irand 8)
d1 $ up (scale "major" "0 1 2 3 4 5 6 7") # sound "arpy"
d1 $ sound "bd*8" # speed (slow 2 $ scale 0.5 2 $ sine)
```

## SuperDirt Samples

Algunos samples disponibles:

```text
808, 909, ade, arpy, bass, bd, birds, bleep, breaks,
casio, cp, drum, east, electro, future, gretsch,
hh, jazz, jungle, kurt, latibro, less, metal, noise,
perc, peri, pluck, rave, sd, speech, tabla, toys, wind
```

## Cargar samples propios

```supercollider
// En SuperCollider:
~dirt.loadSoundFiles("/ruta/a/tus/samples/*");
```

## Snippets útiles

```haskell
d1 $ linger "<1 0.5 0.25 0.125>" $ sound "bd sd cp hh"

d1 $ spread ($) [fast 2, rev, slow 2, striate 3, (# speed "0.8")]
   $ sound "[bd*2 [bd]] [sn future]*2 cp jvbass*4"

d1 $ loopAt 4 $ chop 32 $ sound "breaks125"
```

## Configuración del entorno

### SuperDirt (SuperCollider)

El archivo `my_superdirt_startup.scd` contiene la configuración para iniciar SuperDirt en SuperCollider. Ejecútalo para configurar el servidor de audio antes de usar TidalCycles.

### Archivo de arranque TidalCycles

El archivo `BootTidal.hs` contiene la configuración para iniciar TidalCycles y conectarlo con SuperDirt. La extensión de VS Code lo cargará automáticamente al abrir un archivo `.tidal`.

### VS Code

Recuerda que tienes configurado VS Code para trabajar con TidalCycles:

- Los archivos `.tidal` se reconocen como Haskell
- La extensión busca automáticamente `BootTidal.hs` en la raíz del proyecto
- Teclas de ejecución: `Shift+Enter` (una línea) y `Ctrl+Enter` (múltiples líneas)
