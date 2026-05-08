# Tidal Cycles — Estudio Personal

Repositorio personal de estudio, práctica y enseñanza de **[Tidal Cycles](https://tidalcycles.org/)**: un entorno de live coding musical embebido en Haskell.

Aquí conviven tres tipos de material:

- **Documentación** (referencia teórica y artículos seminales).
- **Talleres** completos listos para impartir (Tidal Cycles y SuperCollider).
- **Código `.tidal`** organizado por curso, técnicas y estilos musicales.

---

## Estructura del repositorio

```text
tidal-cycles/
├── README.md                ← Este archivo
│
├── docs/                    ← Documentación teórica y de referencia
│   ├── README.md            ← Índice general de la documentación
│   ├── cheatsheet.md        ← Cheat sheet personal (snippets de uso rápido)
│   ├── wiki/                ← Wiki en español: 13 capítulos progresivos
│   ├── articles/            ← Artículos y notas en formato markdown
│   └── papers/              ← Papers académicos en PDF
│
├── workshops/               ← Currículos de talleres
│   ├── tidal-cycles/        ← Taller propio de Tidal en 5 sesiones
│   └── supercollider/       ← Taller paralelo de SuperCollider en 5 sesiones
│
└── code/                    ← Código de práctica en .tidal
    ├── course/              ← Ejercicios de aprendizaje progresivo
    ├── techniques/          ← Snippets enfocados en técnicas concretas
    ├── music-styles/        ← Sets temáticos por género (dub techno, grime, perlon...)
    └── jamuary/             ← Jams diarias estilo Jamuary
```

---

## Por dónde empezar

### Si nunca has tocado Tidal

1. Lee la [introducción de la wiki](docs/wiki/01-introduccion.md).
2. Sigue la [guía de instalación](docs/wiki/03-instalacion.md).
3. Empieza el [taller de Tidal Cycles](workshops/tidal-cycles/README.md) en orden (5 sesiones).

### Si ya conoces lo básico

- Profundiza en [conceptos fundamentales](docs/wiki/04-conceptos-fundamentales.md) y [transformaciones](docs/wiki/07-transformaciones.md).
- Explora los sets de [`code/music-styles/`](code/music-styles/) para ver cómo se montan piezas con género.
- Usa el [cheat sheet](docs/cheatsheet.md) como referencia rápida durante el live coding.

### Si quieres impartir un taller

- Currículo completo en [`workshops/tidal-cycles/`](workshops/tidal-cycles/README.md).
- Compara con la versión equivalente en [`workshops/supercollider/`](workshops/supercollider/README.md).

---

## Configuración del entorno

Para poder ejecutar el código `.tidal` necesitas:

1. **Haskell** (vía [`ghcup`](https://www.haskell.org/ghcup/)) + librería Tidal: `cabal install tidal --lib`.
2. **SuperCollider** desde [supercollider.github.io](https://supercollider.github.io/).
3. **SuperDirt** instalado como Quark dentro de SuperCollider.
4. **Editor con plugin Tidal**: VS Code, Pulsar, Emacs o Vim.

Guía detallada: [`docs/wiki/03-instalacion.md`](docs/wiki/03-instalacion.md).

### En VS Code

- Los archivos `.tidal` se reconocen como Haskell.
- La extensión busca automáticamente `BootTidal.hs` en la raíz del proyecto.
- Atajos: `Shift+Enter` (línea), `Ctrl+Enter` (bloque).

---

## Licencia y uso

Material recopilado para estudio personal. Los artículos académicos en [`docs/papers/`](docs/papers/) pertenecen a sus autores originales. La wiki, los talleres y el código propio se ofrecen bajo el espíritu del live coding: úsalos, modifícalos, compártelos.

> *"Show us your screens."* — TOPLAP
