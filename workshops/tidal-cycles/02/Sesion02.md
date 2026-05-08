# Sesión 2: Patrones, Ciclos y Transformaciones

> Recordatorio: SuperCollider abierto, SuperDirt corriendo, archivo `.tidal` listo. Mantén una línea en blanco entre bloques.

En esta sesión vamos a sacarle el jugo a la mini-notación y a las **funciones de orden superior**, que son las que convierten un loop básico en una pieza musical viva.

---

## Ejercicio 1: Polirritmos y polimetría

Hasta ahora nuestros patrones eran lineales. Vamos a apilar capas con **distinta cantidad de pasos** dentro del mismo ciclo.

```haskell
-- Polirritmo con [a, b]: ambos sub-patrones se ajustan al mismo ciclo,
-- aunque tengan distinto número de pasos
d1 $ sound "[bd sn, hh hh hh hh hh]"

-- Más capas
d1 $ sound "[bd ~ sn ~, hh*8, ~ ~ cp ~]"
```

```haskell
-- Polimetría con {a, b}: el lado IZQUIERDO fija el pulso,
-- el resto "flota" sobre él
d1 $ sound "{bd sn, can:2 can:3 can:1, arpy arpy:1 arpy:2 arpy:3 arpy:5}"
```

> **Diferencia clave:** `[ , ]` ajusta los dos lados al ciclo (polirritmo). `{ , }` deja al patrón derecho desfasarse cíclicamente respecto al izquierdo (polimetría).

---

## Ejercicio 2: Ritmos euclidianos `(n, m, r)`

El algoritmo de **Bjorklund** distribuye `n` golpes lo más uniformemente posible en `m` pasos. De ahí salen muchos ritmos clásicos del mundo (cubanos, balcánicos, africanos) con dos números.

```haskell
-- 5 bombos repartidos en 8 pasos = un clásico
d1 $ sound "bd(5,8)"

-- 3 en 8 = tresillo cubano
d1 $ sound "bd(3,8)"

-- Apilando dos euclidianos en distintos canales
d1 $ sound "bd(3,8)"
d2 $ sound "cp(5,8)"

-- Tercer parámetro: rotación
d1 $ sound "bd(5,8,2)"
```

> **Reto:** Combina `bd(3,8)` con `sn(5,16)` y `hh(7,12)`. ¿Encuentras un punto donde los tres se vuelven a alinear? Eso es un *gran ciclo*.

---

## Ejercicio 3: Transformaciones de tiempo

Las transformaciones más comunes manipulan el **arco de tiempo** del patrón.

```haskell
-- Estirar un patrón: ahora ocupa 2 ciclos
d1 $ slow 2 $ sound "arpy arpy:1 arpy:2 arpy:3"

-- Comprimir: dos repeticiones por ciclo
d1 $ fast 2 $ sound "arpy arpy:1 arpy:2 arpy:3"

-- fast con un patrón: cada ciclo cambia la velocidad
d1 $ fast "2 3 4" $ sound "bd sn arpy"

-- Reversa
d1 $ rev $ sound "arpy arpy:1 arpy:2 arpy:3"

-- Ida y vuelta
d1 $ palindrome $ sound "arpy arpy:1 arpy:2 arpy:3"

-- iter: empieza en otro punto cada ciclo
d1 $ iter 4 $ sound "arpy arpy:1 arpy:2 arpy:3"
```

> **Concepto clave:** En Tidal, `slow` y `fast` no cambian el tempo global; reescalan el patrón **dentro del ciclo**.

---

## Ejercicio 4: Funciones de orden superior

Una función de orden superior recibe **otra función** como argumento. Son la herramienta más poderosa de Tidal.

```haskell
-- every N f p: aplica f cada N ciclos
d1 $ every 4 (fast 2) $ sound "arpy arpy:1 arpy:2 arpy:3"

-- Con efectos: cada 3 ciclos sube el speed
d1 $ every 3 (# speed 2) $ sound "arpy*4"

-- jux f p: aplica f sólo al canal derecho del estéreo
d1 $ jux rev $ sound "bd cp sn hh"
d1 $ jux (hurry 2) $ sound "arpy arpy:1 arpy:2 arpy:3"

-- chunk N f p: aplica f a un trozo distinto en cada ciclo
d1 $ chunk 4 (# speed 2) $ sound "alphabet:0 alphabet:1 alphabet:2 alphabet:3"
```

```haskell
-- sometimes / often / rarely / almostNever / almostAlways
d1 $ sometimes (# speed "2") $ sound "drum*8"
d1 $ rarely    (juxcut rev)  $ sound "bd(5,8) sn"
d1 $ often     (fast 2)      $ sound "arpy*4"
```

> **Truco profesional:** Encadena varias transformaciones con `.` (composición de funciones) cuando vas a aplicarlas todas como una sola unidad:

```haskell
d1 $ jux (rev . slow 1.5) $ sound "arpy arpy:1 arpy:2 arpy:3"
```

---

## Ejercicio 5: Replicación, elongación y selección compleja

Más mini-notación expresiva.

```haskell
-- !  REPLICA manteniendo la duración (4 eventos del mismo tamaño)
d1 $ sound "bd!3 sn"
-- Distinto de:
d1 $ sound "bd*3 sn"  -- 3 bd comprimidos en la mitad, sn en la otra mitad

-- _  o  @N  ELONGA el evento previo
d1 $ sound "bd bd _ _ arpy _"
d1 $ sound "bd bd@5 arpy _"

-- Rangos numéricos con ..
d1 $ n "0 .. 7" # sound "arpy"
```

---

## Ejercicio 6: Modulación de parámetros con patrones

Cualquier parámetro de Tidal puede ser un patrón. Esa es la idea más potente del lenguaje.

```haskell
-- Volumen patroneado
d1 $ sound "bd hh sn:1 hh sn:1 hh" # gain "1 0.7 0.5"

-- Paneo patroneado
d1 $ sound "numbers:1 numbers:2 numbers:3 numbers:4" # pan "0 0.5 1"

-- Velocidad de reproducción patroneada
d1 $ sound "numbers:1 numbers:2 numbers:3 numbers:4" # speed "1 1.5 2 0.5"

-- Estructura desde la IZQUIERDA (4 eventos) -> el lado derecho se mapea a 4
d1 $ sound "drum drum drum drum" # vowel "a o e e"

-- Si invertimos lados, la estructura cambia
d1 $ vowel "a o ~ i" # sound "drum"
```

---

## Ejercicio 7: Composición tipo "set"

Cuando empiezas a tocar de verdad, lo normal es tener varios `dN` simultáneos y modificarlos en caliente.

```haskell
setcps 0.55

d1 $ every 4 (fast 2) $ sound "bd(3,8)"

d2 $ jux rev $ sound "~ cp ~ cp" # gain 0.85

d3 $ sometimes (# speed 2) $ n "0 .. 7" # sound "arpy" # gain 0.6

d4 $ struct "t(3,8)" $ sound "bass" # n (irand 12) # gain 0.7
```

```haskell
-- Mezcla en vivo
solo 1
unsolo 1
mute 3
unmuteAll
d2 silence
hush
```

---

## Reto final de la sesión

Crea un *groove* de 16 ciclos:

1. Patrón de batería con bombo+caja+hat usando al menos un ritmo euclidiano.
2. Una línea melódica con `arpy` o `bass` que use `<>` para cambiar cada ciclo.
3. Un canal de hi-hats con `sometimes` para que tenga variación.
4. Un cuarto canal que aparezca **sólo cada 4 ciclos** (pista: `every 4 (...)` o `mask`).

> **Pregunta para la clase:** ¿Cómo describiríais con palabras la diferencia entre `fast 2` y `density 2`? ¿Y entre `*` y `!`? Cuanto mejor entiendas estas sutilezas, más limpio será tu set.
