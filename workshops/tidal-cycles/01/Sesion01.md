# Sesión 1: Primeros Pasos y Mini-Notación

> Antes de tocar una sola tecla: enciende **SuperCollider** y verifica que **SuperDirt** esté corriendo (si no se inicia solo, ejecuta `SuperDirt.start` desde el editor de SC). Después abre tu editor con plugin de Tidal (Pulsar, VS Code, Emacs, Vim) y crea un archivo con extensión `.tidal`.
>
> Para evaluar código: `Ctrl + Enter` (Windows/Linux) o `Cmd + Enter` (Mac).
>
> Para detener todo: `hush` o `Ctrl + .`

---

## Ejercicio 1: ¡Hola, ciclo!

El objetivo es comprobar que toda la cadena (Tidal → SuperCollider → SuperDirt → altavoces) funciona y entender qué es un ciclo.

```haskell
-- 1. Verificamos la versión instalada
tidal_version

-- 2. Nuestro primer sonido: un bombo cada ciclo
d1 $ sound "bd"

-- 3. Detenemos
hush
```

> Si oyes un bombo a velocidad de "1 segundo cada uno", ¡estás dentro! Ese pulso constante es **el ciclo**, la unidad de tiempo central de Tidal.

---

## Ejercicio 2: Secuencias en mini-notación

La **mini-notación** es la sintaxis que va entre comillas. Cada token separado por espacios es un evento, y todos juntos se reparten *uniformemente* dentro del ciclo.

```haskell
-- Dos eventos por ciclo
d1 $ sound "bd sn"

-- Cuatro eventos: el doble de rápido (porque entran 4 en el mismo ciclo)
d1 $ sound "bd hh sn hh"

-- Más eventos = más velocidad aparente
d1 $ sound "bd bd hh bd sn bd hh bd"
```

> **Idea clave:** El ciclo NO se alarga cuando agregas más eventos. Cada paso simplemente se hace más corto. Si quieres bajar la "velocidad real", cambia el tempo:

```haskell
setcps 0.6   -- 0.6 ciclos por segundo (más lento)
setcps 1     -- ~120 BPM si pensamos en 2 negras por ciclo
```

---

## Ejercicio 3: Silencios, agrupaciones y selección de samples

Empezamos a esculpir patrones más expresivos.

```haskell
-- Silencio con ~
d1 $ sound "bd ~ sn ~"

-- Subagrupación con [ ]: dos eventos en un solo paso
d1 $ sound "bd [bd cp] bd bd"

-- Anidación: combina y multiplica posibilidades
d1 $ sound "[[bd bd] hh sn] [bd cp]"

-- Seleccionar un sample concreto de la carpeta con :N
d1 $ sound "bd:1 sn:3 bd:0 sn:5"

-- Equivalente con la función n
d1 $ sound "bd sn bd sn" # n "1 3 0 5"
```

> **Truco:** En la carpeta de SuperCollider, busca *File → Open user support directory → downloaded-quarks → Dirt-Samples*. Cada subcarpeta es un nombre que puedes usar con `sound`. Hay cientos.

---

## Ejercicio 4: Repetición, división, alternancia y aleatoriedad inline

Cuatro símbolos de mini-notación que añaden mucha vida con muy pocos caracteres.

```haskell
-- *  repite COMPRIMIENDO el evento
d1 $ sound "bd sd*2"          -- el sd se divide en dos golpes

-- /  estira (toca el evento cada N ciclos en su sitio)
d1 $ sound "bd sn/2"           -- sn aparece sólo en ciclos pares

-- < >  alternancia entre ciclos
d1 $ sound "bd <sn cp arpy>"   -- ciclo 1: bd sn, ciclo 2: bd cp, ciclo 3: bd arpy

-- |  elige al azar entre opciones
d1 $ sound "[bd|cp|sn] hh*4"

-- ?  degrada (50% de chance de quitar el evento)
d1 $ sound "hh*16?"
```

---

## Ejercicio 5: Los operadores `$` y `#` (la columna vertebral)

`$` aplica una función al patrón de la derecha, evita un mar de paréntesis y se lee de derecha a izquierda. `#` combina dos `ControlPattern` (uno fija la estructura rítmica, otro aporta parámetros).

```haskell
-- Equivalentes
d1 $ sound "bd hh sn hh"
d1 (sound "bd hh sn hh")

-- Encadenando funciones con $: se lee de derecha a izquierda
d1 $ fast 2 $ rev $ sound "bd hh arpy"
-- = d1 (fast 2 (rev (sound "bd hh arpy")))

-- Combinando parámetros con #: la estructura viene del lado IZQUIERDO
d1 $ sound "bd hh sn hh" # gain "1 0.7 0.5 0.7"
                        # pan  "0 1 0.5 1"
```

> Errores comunes que verás (y aprenderás a leer):
> - "Couldn't match expected type `Pattern String`": olvidaste comillas o un `$`.
> - "parse error (possibly incorrect indentation)": cuida los saltos de línea y la indentación.

---

## Ejercicio 6: Múltiples canales y modulación de parámetros

Tidal expone 16 canales independientes (`d1` a `d16`) que comparten reloj. Cada uno acepta un patrón completo.

```haskell
-- Tres patrones simultáneos en sincronía
d1 $ sound "bd(5,8)"
d2 $ sound "bass*8" # gain 0.7
d3 $ sound "arpy(3,8)" # speed (irand 12)

-- Solo, mute, silencio puntual
solo 2
unsolo 2
mute 1
unmuteAll
d3 silence

-- Apaga todo
hush
```

> **Concepto clave para la clase:** Tidal no detiene los samples ya disparados. Si un sample dura 4 segundos, lo seguirás escuchando aunque hagas `hush`. Para cortarlos en seco usa `# cut 1` (lo veremos en la Sesión 3).

---

## Reto final de la sesión

Construye un loop de 4 compases que:

1. Tenga un patrón de bombo y caja con al menos un silencio.
2. Use al menos un ritmo euclidiano `(n,m)` o una alternancia `< >`.
3. Tenga un segundo canal con hi-hats que use `gain` y `pan` patroneados.
4. Cambie cada 4 ciclos algún parámetro (pista: `every 4 (...)`).

> No te preocupes si suena raro. **El error es parte de la performance.** Eso es exactamente live coding.
