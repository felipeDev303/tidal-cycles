# Wiki: Tidal Cycles y Live Coding

Wiki de referencia construida a partir del material en `docs/` (apuntes de Mark Zadel, "Hacking Perl in Nightclubs" de Alex McLean, "Types in tidal-cycles", "TidalCycles Adventures" y el workshop de Lucy Cheesman).

Está pensada como una guía progresiva: primero qué es el live coding y Tidal, luego la instalación, los conceptos centrales, la mini-notación, las transformaciones de patrones, el uso de efectos y síntesis, y finalmente la integración con OSC/MIDI y recursos para profundizar.

## Índice

1. [Introducción a Tidal Cycles](01-introduccion.md)
2. [Live coding: filosofía e historia](02-live-coding.md)
3. [Instalación y primeros pasos](03-instalacion.md)
4. [Conceptos fundamentales: ciclos, patrones y eventos](04-conceptos-fundamentales.md)
5. [Mini-notación de patrones](05-mini-notacion.md)
6. [Haskell, tipos y operadores (`$`, `#`, `.`)](06-haskell-y-operadores.md)
7. [Transformaciones de patrones](07-transformaciones.md)
8. [Sonido, samples y efectos](08-sonido-y-efectos.md)
9. [Aleatoriedad y variación](09-aleatoriedad.md)
10. [Sintetizadores, notas y armonía](10-sintetizadores-y-notas.md)
11. [Performance live: organización del código](11-performance.md)
12. [OSC, MIDI y multicanal](12-osc-midi.md)
13. [Recursos y referencias](13-recursos.md)

## Sobre las fuentes

- `fundamentals-tidalcycles.md` — Mark Zadel, "Learning Tidal Fundamentals" (2021). Recorrido por los tipos y la API interna desde `ghci`.
- `types-tidalcycles.md` — "Types in tidal-cycles". Tidal explicado para programadores: semántica de `Pattern`, `Event`, `Arc`.
- `tidalcycles-adventures.md` — Tutorial extendido sobre Tidal con énfasis en práctica, OSC, performance.
- `workshop.md` — Workshop introductorio de Lucy Cheesman, adaptado por Alex McLean.
- `hacking perl in nightclubs.md` — Alex McLean (2004). Texto seminal sobre live coding antes de Tidal.
