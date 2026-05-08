# 2. Live Coding: filosofía e historia

El **live coding** es la práctica de escribir código en vivo, frente a un público, como acto creativo y performativo. Aplicado a la música, significa que el código fuente se vuelve *partitura e instrumento al mismo tiempo*: el programa corre mientras se modifica.

## La idea central

Como escribió Alex McLean en *"Hacking Perl in Nightclubs"* (2004):

> Una partitura musical es una clase de código fuente, y una performance musical es una clase de programa en ejecución. Cuando ejecutas un programa o tocas una partitura, estás dando vida a un conjunto de instrucciones.

McLean parte de una analogía entre programar y bailar: ambos son inmersiones en estructuras animadas que se construyen y se deshacen hasta llegar a una conclusión. El paso clave del live coding es asumir que **la improvisación también puede ocurrir en el código**: si un programador está en escena, debería *programar* en escena, no solo lanzar scripts pre-hechos.

## Software de consumo vs. live programming

McLean distingue dos formas en las que código y música suelen encontrarse:

1. **Software de consumo**: el músico usa una aplicación (Ableton, Logic, etc.) y los límites de la composición están definidos por quien escribió el software.
2. **Live programming**: el músico **escribe su propio software** mientras toca, lo que rompe esos límites y vuelve la composición transparente.

Tidal, SuperCollider, Sonic Pi, FoxDot, Hydra y otros pertenecen al segundo grupo.

## TOPLAP

En 2004 se funda **TOPLAP** (Temporary Organisation for the Promotion of Live Algorithm Programming, [toplap.org](https://toplap.org)), que establece principios como:

- Mostrar la pantalla al público (la pantalla es parte de la performance).
- El algoritmo es una expresión humana, no debe esconderse.
- El live coder se compromete con la programación como acto público.

## De `feedback.pl` a Tidal

El primer entorno de live coding de McLean fue `feedback.pl`, un editor de Perl que tenía dos hilos: uno editaba código, el otro lo ejecutaba en bucle re-parseándose con `Ctrl+X` sin perder estado. Incluso podía editar su propio código fuente para dar feedback al usuario (de ahí el nombre).

Ese trabajo, junto con la sincronización por *bangs* (un servidor central de tempo `tm.pl`), sembró las ideas que más tarde cristalizarían en Tidal: un lenguaje pequeño, evaluable en caliente, basado en patrones cíclicos sincronizados.

## Música generativa

Tidal pertenece a la tradición de la **música generativa**: en lugar de escribir nota a nota, el compositor escribe el sistema que *genera* la melodía o el ritmo. El compositor da un paso atrás y trabaja con la **estructura detrás de la composición** más que con la composición en sí.

Este enfoque favorece:

- **Polirritmos** y combinaciones de signaturas de tiempo difíciles de notar a mano.
- **Variación controlada** mediante azar acotado.
- **Densidad de material** con muy poco código.

## El *specious present* y los ciclos

La idea de que un patrón habita un *arco de tiempo* (no un instante puntual) tiene una raíz filosófica: el **specious present** o presente especioso, la duración psicológica del "ahora". En Tidal, un evento siempre tiene duración: vive en un `Arc` con inicio y final, lo que se alinea con esa fenomenología del presente.

## Algorave

El género/escena **Algorave** (algorithmic + rave) nació de TOPLAP y reúne eventos donde se baila a música generada por código en vivo. Tidal es una herramienta dominante en esa escena.

Continúa con [Instalación](03-instalacion.md) o [Conceptos fundamentales](04-conceptos-fundamentales.md).
