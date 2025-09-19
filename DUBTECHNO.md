# Consejos Fundamentales de Producción de Dub Techno

## 1. Enfocarse en la Textura y la Atmósfera

- El dub techno se trata de la textura y el ambiente (the real vibecoding?).
- La clave de este género es su sentido de atmósfera, además de los acordes con grandes cantidades de reverberación y delay.
- Se trata de sutileza y textura.
- Es crucial la experimentación.
- Intenta incluir diferentes capas de textura/ruido y capas de procesamiento paralelo.

## 2. Inspiración y Referencias

- Escucha dub. Escucha lo que inspiró las pistas que tanto te gustan y usa esa chispa para alimentar tu propia creatividad.
- Escucha ambient, dub, new age, grabaciones de campo (field recordings), etc., para empaparte de texturas y movimientos sutiles.
- Vuelve a las raíces adecuadas del sonido y escucha el dub reggae auténtico, especialmente a pioneros como King Tubby y Lee Perry.
- Escucha a Basic Channel.
- Tómate tiempo para escuchar los clásicos del género.
- Utiliza una pista de dub techno que te guste como referencia. Obsérvala para ver cómo está arreglada y escucha atentamente cómo los diferentes elementos van y vienen.

## 3. Técnicas de Mezcla y Efectos (El Componente "Dub")

- Aprende sobre las técnicas de mezcla de dub.
- Gran parte del dub techno se basa en cambios en la mezcla (filtros, delays y reverberaciones) en lugar de cambios melódicos.
- Utiliza reverberación y delay en grandes cantidades.
- Utiliza mucho reverb y delay en paralelo.
- Aplica un dub delay a las notas típicas de 8ª y 16ª. Al final, no necesitarás tantas notas.
- Utiliza diferentes delays en secuencia o en paralelo, y modula y automatiza sus parámetros.
- Para evitar sonar aburrido, utiliza LFOs para ajustar filtros, ecualizadores, el feedback del delay y otros parámetros, de modo que el sonido esté siempre evolucionando sutilmente.
- Crea "accidentes felices": Sé atrevido con el delay o la reverberación y remuestrea el resultado. Luego puedes invertirlo, subir o bajar el tono y reorganizar el orden de los golpes.
- Si no usas hardware, una técnica divertida para los pads es usar la señal húmeda (wet) de tu reverberación/delay, grabar el audio y manipularlo (estirando o invirtiendo el audio).
- Experimenta con cualquier tipo de tape delay que puedas modular.

## 4. Sonido y Procesamiento

- Si trabajas "in the box" (con software), intenta emular hardware antiguo usando emulaciones de cinta, saturación o distorsión.
- Usa convolución (como MConvolution) no solo para reverberaciones, sino también para agregar texturas a acordes o baterías y que suenen menos digitales.
- Considera plugins específicos como Modnetic, o plugins útiles para la producción de dub como los de AudioDamage, AudioThing y Nembrini.

## 5. Elementos Melódicos

- Utiliza una gran influencia del jazz en las progresiones de acordes.
- Busca progresiones de acordes usando acordes menores de 7ª y 9ª.
- Usa acordes en abundancia, específicamente un acorde menor.

## 6. Percusión y Ritmo

- Escucha las líneas de bajo en las pistas de dub-reggae.
- Utiliza un kit 808.
- Configura el kit de batería de modo que ningún sonido sea dominante.
- El kick (bombo) debe estar mayormente filtrado hacia abajo, de modo que solo pasen las frecuencias de bajos.

## 7. Flujo de Trabajo y Experimentación

- Evita el error de intentar hacer dub techno de la misma manera que harías house o techno de 16 compases (dibujando automatizaciones). Esto resulta en música plana y sin vida.
- Configura tu DAW con efectos en los returns que se retroalimenten entre sí.
- Toma 4-6 loops y simplemente jammea con ellos sobre la marcha. Esta es la esencia de la música dub.
- Graba tus propios sonidos (el sonido de la lluvia, una tormenta, la ciudad de noche o el bosque al mediodía).
- Añade grabaciones de campo (field recordings) para mejorar el ambiente.
- Añade silbido de fondo (background hiss).
- Experimenta con el diseño de sonido, el timbre y los ritmos. Si bien los consejos técnicos son útiles, la magia ocurre cuando puedes sentir algo y hacer que otros lo sientan también.

## 8. Aprendizaje y Referencia (Profundización)

- Si usas una pista de referencia, intenta recrear cada elemento (batería, bajo, partes melódicas, extras) en diferentes pistas, consultando constantemente la canción original. Esto sirve para aprender cómo crear cada elemento por separado y construir una base para componer tus propias pistas.

## Implementación en TidalCycles

```haskell
-- Ejemplo básico de dub techno en TidalCycles
d1 $ stack [
  -- Kick filtrado y submix
  s "bd(3,8)" # lpf 300 # gain 0.9,

  -- Hi-hats con variación sutil
  s "hh*8" # gain (range 0.4 0.6 $ slow 4 $ sine) # pan (rand),

  -- Acorde menor con reverb y delay
  n "c3'min7" # s "supersaw" # gain 0.7
    # room 0.8 # size 0.9
    # delay 0.6 # delaytime (1/3) # delayfeedback 0.7
    # lpf (range 300 1200 $ slow 8 $ sine)
] # orbit 0
```

## Artistas de Referencia

- Basic Channel / Maurizio
- Deepchord / Echospace
- Rhythm & Sound
- Fluxion
- Intrusion
- King Tubby
- Lee "Scratch" Perry
