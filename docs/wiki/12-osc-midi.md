# 12. OSC, MIDI y multicanal

Tidal puede enviar mensajes a cualquier receptor que entienda OSC o MIDI: synths externos, DAWs, motores de visuales, hardware...

## Salida multicanal vs separada

- **Multichannel**: un solo `out` de SuperCollider con varios canales (p. ej. cuadrafónico). Útil para distribuir paneo en una instalación con 4 o más altavoces.
- **Salida separada**: varios outs independientes que pueden enrutarse a buses, DAWs o tarjetas multicanal. Cada uno se direcciona con `# orbit N`.

Para enrutar internamente a tu DAW se recomienda un router de audio como **JackAudio** (multiplataforma, libre).

## `orbit`: el bus de Tidal

```haskell
d1 $ s "bd*4" # orbit 0
d2 $ s "cp"   # orbit 1
```

Los orbits con el mismo número **comparten efectos globales** (delay, reverb), lo que es bueno para la cohesión sónica y para optimizar CPU.

## OSC personalizado

Puedes definir destinos OSC propios en tu `BootTidal.hs`:

```haskell
:{
let myTarget :: OSCTarget
    myTarget = OSCTarget
      { oName      = "myTarget"
      , oAddress   = "127.0.0.1"
      , oPort      = 7000
      , oPath      = "/tidal"
      , oShape     = Nothing
      , oLatency   = 0.02
      , oPreamble  = []
      , oTimestamp = MessageStamp
      }
:}
```

> Las llaves `:{` y `:}` son **necesarias en GHCi** para bloques multi-línea.

| Campo | Significado |
|---|---|
| `oName` | Nombre interno del destino |
| `oAddress` | IP del receptor (`127.0.0.1` para local) |
| `oPort` | Puerto UDP en el que escucha el receptor |
| `oPath` | Prefijo de ruta para todos los mensajes |
| `oShape` | Lista de claves esperadas (`Nothing` = todo) |
| `oLatency` | Compensación en segundos |
| `oTimestamp` | Estrategia de timestamp |

## `oShape`: definir el contrato

Si pasas `Nothing` Tidal envía **todos** los parámetros del patrón. Habitualmente quieres una lista explícita:

```haskell
oShape = Just [("level", Just (VF 0))]
```

Significa: "espero una clave `level` con valor float (default 0)". Tipos posibles: `VS` (string), `VF` (double), `VI` (int).

## Funciones para enviar valores

Para dirigir cualquier valor a un parámetro propio, hay constructores genéricos:

```haskell
let mymessage = pS "mymessage"   -- string
let level     = pF "level"       -- double
let voice     = pI "voice"       -- int

d1 $ mymessage "hello world"
d2 $ level "0.5 1"
```

Tidal hará conversión automática entre `pF` y `pI` cuando sea posible (`5` ↔ `5.0`).

## Ejemplo: visuales con Unity

```haskell
:{
let unityTarget :: OSCTarget
    unityTarget = OSCTarget
      { oName      = "Unity"
      , oAddress   = "127.0.0.1"
      , oPort      = 7000
      , oPath      = "/tidal/"
      , oShape     = Just [("trigger", Nothing), ("color", Just (VS ""))]
      , oLatency   = 0.02
      , oPreamble  = []
      , oTimestamp = MessageStamp
      }
:}
```

Y desde el código:

```haskell
let trigger = pI "trigger"
    color   = pS "color"

d1 $ trigger "1 0 1 0" # color "red blue"
```

Unity recibirá mensajes en `/tidal/` con campos `trigger` (int) y `color` (string).

## Caveats al configurar OSC

- Si el destino es remoto y la **red no está disponible**, Tidal puede fallar al arrancar silenciosamente. Verifica conexión antes de tocar.
- Las IPs locales pueden cambiar entre redes. Si tu setup vive en otra red, tendrás que actualizar `oAddress`.
- La indentación en Haskell **importa**: una sola línea desalineada rompe la definición del target.

## MIDI

MIDI funciona enviando mensajes a través de SuperCollider. Pasos generales:

1. Configurar SuperCollider para crear un device MIDI virtual o usar uno real (consultar la guía oficial *MIDI* y *MIDI Clock* en tidalcycles.org).
2. Definir un destino MIDI similar al OSC en el `BootTidal.hs`.
3. Usar funciones específicas (`midicmd`, `ccv`, `ccn`) para mandar Notes/Control Change.

```haskell
d1 $ note "c a f e" # s "midi" # midichan 0
d2 $ ccv "0 32 64 127" # ccn 1 # s "midi"
```

> En Windows el camino MIDI suele ser frágil (drivers virtuales antiguos). En macOS y Linux es más fluido.

Continúa con [Recursos](13-recursos.md).
