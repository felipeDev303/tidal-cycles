# Taller de Tidal Cycles

**Live coding musical desde el patrón y el ciclo**

Aprende a improvisar música escribiendo código en vivo y descubre el universo del live coding a través de Tidal Cycles.

---

## Descripción del Taller

En este taller aprenderemos a usar [Tidal Cycles](https://tidalcycles.org/) como instrumento de improvisación y composición algorítmica en tiempo real. Partiremos de la mini-notación más básica hasta llegar a la creación de sets generativos completos, polirritmos, manipulación granular de samples y control externo por OSC/MIDI. Durante el curso, exploraremos de forma práctica patrones cíclicos, transformaciones funcionales, ritmos euclidianos, síntesis con SuperDirt y composición algorítmica.

---

## ¿Qué es Tidal Cycles?

[Tidal Cycles](https://tidalcycles.org/) (o simplemente *Tidal*) es un entorno open source de **live coding** y un lenguaje específico de dominio (DSL) embebido en Haskell, orientado a la creación e improvisación de música y patrones de control en tiempo real.

Tidal no produce sonido por sí mismo: genera mensajes de control por **OSC** que envía al motor de audio **SuperCollider** + **SuperDirt**. Esto lo vuelve enormemente flexible: el mismo código puede controlar synths, DAWs, motores de visuales (Hydra, Resolume, Unity, openFrameworks), MIDI, etc.

Su característica distintiva es el **patrón cíclico** como primitivo: el tiempo se mide en *cycles per second* y los patrones se transforman, combinan y modifican en caliente mientras siguen sonando.

> **Tidal Cycles es software libre y está disponible para Windows, macOS y Linux.** Es la herramienta dominante de la escena **Algorave** y proyectos **TOPLAP**.

---

## ¿A quién va dirigido?

Este taller está especialmente diseñado para:

- Personas interesadas en el cruce entre arte, código y música
- Músicos, DJs y productores curiosos de la composición algorítmica
- Programadores con ganas de improvisar con sonido y ritmo
- Artistas digitales y live coders que quieren incorporar audio a su práctica

> **Nota:** No se requieren conocimientos previos de programación ni de teoría musical. Sí ayuda tener algo de oído rítmico y disposición a equivocarse en voz alta (es la esencia del live coding).

---

## Estructura del Repositorio

```
workshops/tidal-cycles/
├── 01/
│   ├── Sesion01.md        # Ejercicios prácticos
│   └── CheatSheet01.md    # Referencia rápida de conceptos
├── 02/
│   └── Sesion02.md
├── 03/
│   └── Sesion03.md
├── 04/
│   └── Sesion04.md
├── 05/
│   └── Sesion05.md
└── README.md
```

---

## Plan de Estudios (5 Sesiones)

### [Sesión 1: Primeros pasos y mini-notación](01/Sesion01.md)

- Arranque del entorno: SuperCollider + SuperDirt + editor con plugin Tidal
- Primer patrón: `d1`, `sound`, `hush` y el bucle del ciclo
- Mini-notación básica: secuencias, silencios `~`, agrupaciones `[ ]`, repetición `*`, división `/`
- Operadores `$` y `#`: cómo encadenar funciones y combinar parámetros
- Selección de samples: `sound "bd:2"` vs `# n 2`, alias `s`
- Conceptos de Haskell mínimos para sobrevivir (sin morir en el intento)

### [Sesión 2: Patrones, ciclos y transformaciones](02/Sesion02.md)

- Mini-notación avanzada: alternancia `< >`, polirritmia `[ , ]`, polimetría `{ , }`, replicación `!`, elongación `_`/`@`
- Ritmos euclidianos `(n,m,r)` y la magia de Bjorklund
- Transformaciones funcionales: `slow`, `fast`, `rev`, `palindrome`, `iter`
- Funciones de orden superior: `every`, `jux`, `chunk`, `sometimes`, `often`, `rarely`
- Múltiples canales (`d1..d16`), `solo`, `mute`, `hush`

### [Sesión 3: Sonido, samples y efectos](03/Sesion03.md)

- Carpetas Dirt-Samples y cómo añadir las propias
- Volumen, paneo, pitch: `gain`, `pan`, `speed`, `up`, `note`
- Filtros y efectos: `cutoff`/`hcutoff`, `resonance`, `vowel`, `shape`, `delay`+`delaytime`+`delayfeedback`+`lock`, `room`/`size`, `dry`
- Samples largos: `cut`, `legato`, `chop`, `striate`, `randslice`, `loopAt`
- Aleatoriedad: `rand`, `irand`, `perlin`, `degradeBy`, `?`, `choose`, `randcat`, `shuffle`

### [Sesión 4: Composición algorítmica y síntesis](04/Sesion04.md)

- Synths de SuperDirt: `superpiano`, `supersaw`, `superfm`, `supermandolin`...
- Diferencia entre `n` y `note` con synths y con samples
- Notación musical: nombres `c d e f g a b`, sostenidos/bemoles, octavas
- Acordes y arpegios: `chord`, `arp`
- Apilar patrones con `stack`; bloques `do` y `let` para preparar material
- Estructura de canción: `seqP`, `seqPLoop`, `ur`, `resetCycles`
- LFOs continuos (`sine`, `saw`, `perlin`) y buses de control (`cutoffbus`)
- Transiciones suaves: `xfade`, `jumpIn`, `anticipate`

### [Sesión 5: Cierre y exhibición — Algorave de clase](05/Sesion05.md)

- Sesión abierta de resolución de dudas y *clínica de código*
- Muestra de los sets en vivo creados por les participantes
- Feedback colectivo y siguientes pasos
- Plantilla de set para presentación final
- Recursos para seguir profundizando (libros, foros, festivales, comunidad)

---

## Material complementario

Este taller se apoya en la wiki en español de Tidal Cycles que vive en este mismo repositorio: [`docs/wiki/`](../../docs/wiki/README.md). Allí encontrarás referencia más detallada de cada concepto.
