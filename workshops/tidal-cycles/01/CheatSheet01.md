# Cheat Sheet: Sesión 1

> Conceptos básicos, atajos y sintaxis para sobrevivir (y hacer ruido) en el primer día de Tidal.

---

## 1. Atajos de Teclado Esenciales

| Acción | Windows/Linux | Mac |
|---|---|---|
| **Iniciar SuperDirt (en SC)** | `Ctrl + Enter` sobre `SuperDirt.start` | `Cmd + Enter` |
| **Evaluar bloque (en Tidal)** | `Ctrl + Enter` | `Cmd + Enter` |
| **Evaluar línea (en algunos editores)** | `Shift + Enter` | `Shift + Enter` |
| **DETENER TODO EL SONIDO** | `Ctrl + .` o `hush` | `Cmd + .` o `hush` |
| **Comentar línea** | `Ctrl + /` | `Cmd + /` |

> Antes de evaluar tu primer patrón, asegúrate de que **SuperCollider esté abierto** y **SuperDirt esté corriendo**. Si Tidal no encuentra a SuperDirt, no oirás nada.

---

## 2. Conceptos Clave del Entorno

- **Tidal**: librería en Haskell que **genera patrones** de mensajes de control, pero NO produce sonido por sí misma.
- **SuperCollider (`scsynth`)**: el motor de audio.
- **SuperDirt**: el sintetizador/sampler que escucha por OSC y produce el sonido.
- **GHCi**: el intérprete de Haskell que el plugin de tu editor lanza por debajo. Reevalúa código en caliente sin parar la música.
- **`d1` ... `d16`**: los 16 canales (orbits) que envían patrones al motor de audio.
- **Ciclo (cycle)**: la unidad de tiempo de Tidal. Un ciclo es un loop continuo donde se reparten todos los eventos del patrón.
- **Mini-notación**: la sintaxis tipo string entre comillas, con su propio parser.

---

## 3. Sintaxis y Reglas Básicas

- **Comentarios**: igual que en Haskell.

```haskell
-- Comentario de una sola línea

{-
   Comentario
   de varias líneas
-}
```

- **Bloques de código**: Tidal evalúa por bloques separados por **líneas en blanco**. Mantén una línea vacía entre `d1`, `d2`, etc.
- **No hay `;`**: a diferencia de SuperCollider, Tidal NO usa punto y coma.
- **Indentación importa**: si encadenas funciones en varias líneas, alinéalas.

---

## 4. La fórmula básica de un patrón

```haskell
d1 $ sound "bd sn cp hh"
   # gain "1 0.7 0.8 0.7"
   # pan  "0 0.5 1 0.5"
```

| Parte | Qué hace |
|---|---|
| `d1` | Manda este patrón al canal/orbit 1 |
| `$` | Aplica la función de la izquierda al patrón de la derecha (evita paréntesis) |
| `sound "..."` | Convierte el string en un patrón de control con la clave `s` |
| `#` | Combina dos `ControlPattern`. La **estructura rítmica** viene de la izquierda |
| `"bd sn ..."` | Mini-notación: cada token = un evento; se reparten en el ciclo |

---

## 5. Tabla rápida de mini-notación

| Símbolo | Significado | Ejemplo |
|---|---|---|
| espacio | Separa eventos | `"bd sn cp"` |
| `~` | Silencio | `"bd ~ sn ~"` |
| `[ ]` | Subagrupación (1 paso) | `"bd [hh hh] sn"` |
| `*N` | Repetir N veces dentro del paso | `"bd sd*2"` |
| `/N` | Estirar (cada N ciclos) | `"sn/2"` |
| `<a b c>` | Alternar entre ciclos | `"bd <sn cp>"` |
| `\|` | Elegir uno al azar (en `[ ]`) | `"[bd\|cp]"` |
| `?` | Quitar al 50% | `"hh*16?"` |
| `:N` | Sample N de la carpeta | `"bd:2"` |
| `(n,m)` | Ritmo euclidiano | `"bd(5,8)"` |

---

## 6. Funciones útiles para el primer día

```haskell
-- Tempo
setcps 0.5      -- 0.5 ciclos por segundo
resetCycles     -- reinicia el contador de ciclos

-- Selección de sample (alternativa a "bd:2")
d1 $ sound "drum" # n "0 1 2 3"

-- Estructura desde el lado izquierdo: gana el ritmo de "drum drum drum drum"
d1 $ sound "drum drum drum drum" # vowel "a o e"

-- Volumen, paneo, pitch
d1 $ sound "arpy*4" # gain 0.7 # pan "0 1 0.5 1" # speed "1 1 2 0.5"

-- Frenar
hush            -- todos los canales
mute 1          -- silencia d1
solo 2          -- escucha sólo d2
unmuteAll
d1 silence      -- detiene sólo d1
```

---

## 7. Operadores `$` y `#` en una línea

- **`$`**: "aplica la función de la izquierda al valor de la derecha". Sustituye paréntesis. Se lee **de derecha a izquierda**:

```haskell
d1 $ fast 2 $ rev $ sound "bd hh arpy"
-- mismo que: d1 (fast 2 (rev (sound "bd hh arpy")))
```

- **`#`**: combina dos patrones de control fundiendo sus claves. La **estructura rítmica** viene del de la izquierda.

```haskell
d1 $ sound "bd sn" # gain "0.8 1" # pan "0 1"
```

---

## 8. La regla de oro del live coding

> **No tengas miedo del error.** Si Tidal te grita en rojo, lee la primera línea del error: te dirá qué función esperaba qué tipo. Cambia, reevalúa, y la música sigue. La pantalla y el código son parte del show.

---

## 9. Si te quedas atascado

- **Documentación oficial**: <https://tidalcycles.org/docs/>
- **Foro**: <https://club.tidalcycles.org>
- **Discord**: enlace desde la home de tidalcycles.org
- **Wiki interna del proyecto**: [`docs/wiki/`](../../../docs/wiki/README.md)
