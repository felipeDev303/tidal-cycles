# 3. Instalación y primeros pasos

Tidal Cycles depende de varias piezas que conviene entender por separado:

| Componente | Rol |
|---|---|
| **Haskell (GHC + cabal/stack)** | Compilador e intérprete donde corre Tidal. |
| **Tidal** (`Sound.Tidal.Context`) | La librería Haskell que genera patrones. |
| **SuperCollider** | El motor de audio. |
| **SuperDirt** | El sintetizador/sampler que escucha por OSC y produce sonido. |
| **Editor con plugin Tidal** | Pulsar/Atom, VS Code, Emacs, Vim. Ejecuta bloques de código en GHCi. |

## Pasos generales

1. Instalar **Haskell** (recomendado vía [`ghcup`](https://www.haskell.org/ghcup/)).
2. Instalar la librería de Tidal: `cabal install tidal --lib`. La opción `--lib` es importante porque permite hacer `import Sound.Tidal.Context` desde GHCi.
3. Instalar **SuperCollider** desde [supercollider.github.io](https://supercollider.github.io/).
4. Instalar el quark **SuperDirt** desde dentro de SuperCollider.
5. Instalar un editor compatible (Pulsar, VS Code con la extensión `tidalcycles`, Emacs con `tidal-mode`, Vim con `vim-tidal`).

> Para guías oficiales por sistema operativo: [tidalcycles.org/docs/getting-started](https://tidalcycles.org/docs/getting-started).

## Verificar la instalación de la librería

Desde una shell:

```text
$ ghci
Prelude> import Sound.Tidal.Context
Prelude Sound.Tidal.Context> tidal_version
"1.7.8"
```

Esto solo confirma que la librería está disponible; **no es suficiente para producir sonido**. Para sonido se requiere SuperCollider + SuperDirt corriendo.

## Lanzar Tidal por primera vez

1. Abre SuperCollider. SuperDirt suele iniciarse automáticamente; si no, ejecuta `SuperDirt.start` desde el editor de SC.
2. Crea un archivo nuevo en tu editor con extensión `.tidal` (por ejemplo `examples.tidal`).
3. Escribe y evalúa (con `Ctrl+Enter` o `Cmd+Enter`):

```haskell
tidal_version
```

Esto inicia GHCi en segundo plano y debería imprimir la versión.

4. Primer patrón:

```haskell
d1 $ sound "bd"
```

Si oyes un bombo cada segundo, todo está conectado.

5. Para parar:

```haskell
hush
```

## Estuary (sin instalación)

Si no quieres instalar nada, puedes usar [**Estuary**](https://estuarium.org/), un entorno web colaborativo que incluye un subconjunto de Tidal llamado **Mini-Tidal**. No tiene todas las funciones, pero es excelente para aprender, enseñar y tocar a distancia.

## Estructura del arranque (`BootTidal.hs`)

Cuando el plugin del editor inicia Tidal, ejecuta un archivo `BootTidal.hs` que:

- Configura `tidal` como el `Stream` activo.
- Define `d1`, `d2`, ..., `d16` como funciones para enviar patrones a 16 *orbits*/canales OSC.
- Habilita extensiones de Haskell útiles (como `OverloadedStrings`, que permite escribir `"bd"` en lugar de `parseBP_E "bd"`).
- Define helpers como `hush`, `solo`, `unsolo`, `mute`.

Puedes copiar `BootTidal.hs` a la carpeta de tu proyecto para personalizarlo (ver [OSC, MIDI y multicanal](12-osc-midi.md)).

## Solución de problemas comunes

- **`Couldn't match expected type 'Pattern String' with actual type '[Char]'`** en GHCi puro: te falta `:set -XOverloadedStrings`. El plugin del editor lo activa automáticamente.
- **No suena nada**: comprueba que SuperCollider esté corriendo, que SuperDirt esté iniciado y que no haya errores en la ventana post de SC.
- **Latencia o glitches**: revisa el indicador de carga del servidor de SC. Si pasa de 100%, ver [Performance](11-performance.md).

Continúa con [Conceptos fundamentales](04-conceptos-fundamentales.md).
