# Types in tidal-cycles

This is my best attempt at explaining some fundamental design choices in https://tidalcycles.org/, shortly called Tidal, a library for “performances with patterns of time”, by Alex McLean.

My text here is intended as “Tidal for programmers”, and it should complement other (perfectly fine) introductory texts that feel more like “Tidal for musicians”.

So, you probably won’t need this if you just want to use Tidal, but you will hopefully find it useful if you want to understand how the implementation works - may this be out of idle curiousity, or because you want to contribute code.

Beware - this text evolves with my understanding of Tidal. I am pretty certain that I just haven’t grasped some of the reasons for the current design. Some places where I notice this myself are annotated with question marks, and I do welcome explanations, corrections and comments.

See message to Tidal mailing list (view thread, and scroll down, to see answers)

## Version history

- Tue Jan 1, 2019 - update types (Event,Arc) for tidal-1.0.5, ad paragraph on substitutions in the surface language
- Sun Dec 9, 2018 - initial

## A first look at Patterns and Events

For reference, see also https://userbase.tidalcycles.org/index.php/What_is_a_pattern%3F

A pattern p :: Pattern a describes a periodic mapping from time to a. The mapping is given by a sequence (set?) of events of type Event a, where an event has a duration and a value.

The main application of these types will instantiate a by ControlMap, which is a type that represents a collection of key/value pairs that controls how the back-end (the supercollider software synthesizer) renders a sound sample. We will deal with this later, and focus on polymorphic patterns here.

There are two basic patterns, constructed from

- `silence :: Pattern a`, the pattern without any events,
- `pure :: a -> Pattern a`, where `pure x` is the pattern with one event ranging from time 0 to time 1, of value `x`.

Then, there are operations that transform patterns, e.g., `slow :: Time -> Pattern a -> Pattern a` (the type is slightly simplified) such that `slow 2 (pure 1)` is a pattern of length 2 with value 1.

We also have functions that combine patterns

- sequentially: `cat :: [ Pattern a ] -> Pattern a`
- in parallel: `stack :: [ Pattern a ] -> Pattern a`

For example, `cat [pure 0, pure 1, pure 2]` is a `Pattern Int` of period 3, containing three events, each of length 1.

Important: see below for the exact semantics of cat when applied to patterns that don’t have unit length.

## Why this is only a first approximation

The preceding text is already an over-simplification, on several grounds:

- there is a distinction between analog and digital patterns,
- the semantics of a pattern can depend on an environment,
- there are two durations associated to each event.

Let us look at some the actual type declarations:

```haskell
data Pattern a = Pattern {nature :: Nature, query :: Query a}
data Nature = Analog | Digital
type Query a = State -> [Event a]
data State = State {arc :: Arc, controls :: ControlMap}
```

(and we look at `Event a` later on)

We see that the pattern contains a query that can read values from an environment, called State (so, Query a is actually a Reader monad?).

The arc of the current state is used in the following way (?) The pattern is queried by the scheduler for the events that it wants to send to the back-end, during a specific interval of time:

```haskell
queryArc (pure 1) (Arc 0 3)
  ==> [(0>1)|1, (1>2)|1, (2>3)|1]

queryArc (cat [ pure 1, pure 2, pure 3 ]) (Arc 0 3)
  ==> [(0>1)|1, (1>2)|2, (2>3)|3]
```

The controls of the state represents a collection of key/value-pairs that is determined by external means, e.g., names and positions of knobs on a (hardware or software) MIDI controller. This is currently under development.

## A closer look at Events
We said that an `Event a` spans an interval in time, and has a value. But in fact, an event is associated with two intervals (the “whole”, and the “part”).

```haskell
type Event a = EventF Arc a
data EventF a b = Event { whole :: a, part :: a, value :: b }

type Arc = ArcF Time
data ArcF a = Arc {start :: a, stop :: a}
```

We can observe this in the following example

```haskell
queryArc (slow 2 $ pure 1) (Arc 0 2)
  ==> [(0>1)-2|1, 0-(1>2)|1]
  === [ Event { whole = Arc { start = 0, stop = 2 }
              , part  = Arc { start = 0, stop = 1 }
          , value = 1 }
      , Event { whole = Arc { start = 0, stop = 2 }
              , part  = Arc { start = 1, stop = 2 }
          , value = 1 }
      ]
```

where the output lines after “===” show actual data, without the prettyprinting (see note below).

The meaning of e :: Event a is: it is the interval part e of the event that actually occupies interval whole e.

(TODO: clear up) It seems that Tidal always splits events at unit intervals of time (and sometimes in other places). Perhaps the reason is that the back-end shall never handle samples longer than a unit interval. But why?

- it simply cannot? (unlikely)
- it could, but we don’t want it to, since we may want to change parameters on the fly?
- it is required because `pure id <*> p` should be `p`, and `pure id` has period one?

## A closer look at sequential composition (cat)

The earlier example `cat [pure 0, pure 1, pure 2]` suggested that cat is just sequential composition. Far from it!

```haskell
queryArc ( s "[bd sn]/2" ) (Arc 0 2)
==> [(0>1)|s: "bd",(1>2)|s: "sn"]

queryArc ( s "[ho hc hh]/3"  ) (Arc 0 3)
==> [(0>1)|s: "ho",(1>2)|s: "hc",(2>3)|s: "hh"]

queryArc ( cat [s "[bd sn]/2", s "[ho hc hh]/3" ] ) (Arc 0 6)
==> [(0>1)|s: "bd", (1>2)|s: "ho"
    ,(2>3)|s: "sn", (3>4)|s: "hc"
    ,(4>5)|s: "bd", (5>6)|s: "hh"
    ]
```

This shows that the semantics of `cat [p1, .. pn]` is: play each of the `pi`, one after another, for one unit interval.

It could not be any other way: plain sequential composition is impossible, given the data model! To compose two periodic patterns sequentially, we would presumably concatenate the period of the first one with the period of the second one. But patterns are not necessarily periodic - although this is often the case in practice. The type declarations show that there is no way to obtain the “period” of a pattern.

Exercise: We have append a b = cat [a,b]. Is append associative?

Given `cat`, what is `fastcat`? The definition

```haskell
fastCat :: [Pattern a] -> Pattern a
fastCat ps = _fast (toTime $ length ps) $ cat ps
```

shows that we do compute cat, as described above, and then speed up the result, where the speed is the number of arguments. So, one cycle of the result contains one cycle of each of the arguments.

## Combining patterns

We have seen sequential and parallel composition, but there’s another option, let’s call it parallel combination with interaction.

I will explain this, using patterns `run k` where `run k = fastcat $ map pure [0 .. k-1]`

We uses methods from Haskell’s Applicative type class:

```haskell
(,) <$> run 2 <*> run 3
  ==> [(0>1/3)|(0,0), (1/3>1/2)|(0,1), (1/2>2/3)|(1,1), (2/3>1)|(1,2)]
```

We see that the result consists of four events, and their lengths are not identical. Result events are separated whenever (at least) one of the argument patterns (run 2, run 3) separates.

In my opinion, this is the actual semantical invention specific to Tidal, and not present in other systems of algebraic description of music.

It allows a highly compact notation of structured patterns, built from simpler ones, where structure “comes from both sides”.

There are two extra combining forms: `<*` (structure comes from the left), and `*>` (from the right). Each event of the pattern that gives the structure, is combined with the then-current value of the other pattern.

```haskell
(,) <$> run 2 Sound.Tidal.Context.<* run 3
==> [ (0>1/2)|(0,0), (1/2>1)|(1,1) ]

(,) <$> run 2 Sound.Tidal.Context.*> run 3
==> [ (0>1/3)|(0,0), (1/3>2/3)|(0,1), (2/3>1)|(1,2) ]
```

Note that in the first example, there is no value (1,2), and in the last example, there is no value (1,1).

While `<*>` (`<*`, `*>`) is the basic operation, there are abbreviations for common usage. They basically replace the general form

```haskell
(op) <$> p1 <*> p2
```

with

```haskell
p1 |op| p2
```

For instance, when to combine values from patterns by addition,

```haskell
(+) <$> run 2 <*> run 3
==> [(0>1/3)|0, (1/3>1/2)|1, (1/2>2/3)|2, (2/3>1)|3]
```

can be written as

```haskell
run 2 |+| run 3
```

Other arithmetical operators have corresponding “bar forms”.

Similarly, we can replace

```haskell
(op) <$> p1 <* p2   with   p1 |op  p2
(op) <$> p1 *> p2   with   p1  op| p2
```

The bar (`|`) indicates the argumment that determines structure.

## ControlMap, or: how do we actually make a sound

While the text was speaking about patterns in general, let us now talk about patterns for making sound with supercollider. The value type for patterns (and their events) is `ControlMap`.

```haskell
type ControlMap = Data.Map.Internal.Map String Value
data Value = VS String | VF Double | VI Int
```

A `ControlMap` determines a sample, and how it is rendered by the back-end. Important keys for `ControlMap` are

- `s` (sound): a string, naming a directory
- `n` (number): a number, denoting a `*.wav` file in that directory
- `speed`: a number, denoting playback speed for this sample

There are more keys, used to control audio effects, and they can be looked up in the documentation.

For instance, this pattern denotes sample number 1 from the “808” directory, to be played at half speed.

```haskell
import qualified Data.Map as M
pure $ M.fromList [("s", VS "808"), ("n", VF 1), ("speed", VF 0.5)]
```

The “s” key is the only one that is required in a ControlMap to make a sound.

The full diretory name is `$HOME/.local/share/SuperCollider/downloaded-quarks/Dirt-Samples/808`, and it contains 6 files

```
CB.WAV  CH.WAV  CL.WAV  CP.WAV  MA.WAV  RS.WAV 
```

By number 1, we mean “CH.WAV”. Numbers default to 0, and will wrap around (modulo number of files in directory). Speed defaults to 1.

While the previous example will work, we will never write it like this in real life. Instead, we will construct ControlMaps from basic elements, using combinators shown previously.

For each key, there is a function that maps a pattern `p` of values to a pattern of `ControlMap`s containing just this key, and the values as in `p`.

```haskell
queryArc  (s $ pure "808") (Arc 0 1)
==> [(0>1)|s: "808"]

queryArc  (n $ pure 1) (Arc 0 1)
[(0>1)|n: 1.0f]
```

We combine `ControlMap`s (taking the union of their respective sets of key/value pairs)

```haskell
queryArc  (union <$> (s $ pure "808") <*> (n $ pure 1))  (Arc 0 1)
==> [(0>1)|n: 1.0f, s: "808"]
```

A shorthand notation for the same thing is

```haskell
queryArc  ((s $ pure "808") |>| (n $ pure 1))  (Arc 0 1)
==> [(0>1)|n: 1.0f, s: "808"]
```

The two bars in `|>|` indicate that structure comes from both sides (in this example, it does not matter). The direction of `>` indicates that the right-hand argument will determine the values of keys that appear in both `ControlMap`s (which, again, does not happen in this example).

## Surface syntax vs. embedded DSL

We will now add the last missing piece of information to understand typical real-life Tidal notation.

This is about a purely syntactic feature that is important for pragmatics of live coding, as it reduces the amount of typing, that is, keypresses, necessary to describe patterns.

For example, we will never write

```haskell
( s $ pure "808" )  |>| ( n $ pure 1 )
```

but instead use

```haskell
s "808"  |>|  n "1"
```

This works because we have `{-# language OverloadedStrings #-}`, or the equivalent `:set -XOverloadedStrings` in the ghci session, and this will have the compiler insert `fromString` before each string literal. This is the actual code that gets evaluated:

```haskell
s (fromString "808")  |>|  n (fromString "1")
```

where `fromString :: String -> Pattern a` is a parser for a mini-language of pattern descriptions. (The substitution for the type parameter `a` is determined by the compiler, by the context in which the expression is used).

This language has

- elementary patterns
  - silence: write `~`
  - `pure x`, where `x` is a number or a string: write just `x`, and omit string quotes.
- composition:
  - `fastcat`: inside `[ ]`, concatenate patterns, separated by blanks
  - `stack`: inside `[ ]`, concatenate patterns, separated by `,` (comma)
- some transformations, e.g.
  - `fast k x`: write `x*k`
  - `slow k x`: write `x/k`

Exercise: determine the meaning of `"bd [ho hc]/2"`.

## Appendix. Remarks

Some opinions on language design. They are orthogonal to the preceding text.

### Embedded DSL vs. Concrete Syntax

Do you rather write

```haskell
fastcat [ pure "bd", slow 2 $ fastcat [ pure "ho", pure "hc" ] ]
```

or

```haskell
"bd [ho hc]/2"
```

The first example uses tidal as an embedded domain-specific language. Whe use the host language’s (Haskell) syntax, and type system. We can also use the hosts facilities for re-using code: we can write functions, and we can use functions from libraries - that have nothing to do with music. We can also make use of other infrastructure of the host language. For example, with ghc-8.6, we can write a hole (`_`)

```haskell
s $ fastcat [ pure "bd", slow 2 $ _ [ pure "ho", pure "hc" ] ]
```

and ghci will answer

```
Found hole: _ :: [f0 [Char]] -> Pattern a
...
      Valid hole fits include
        cat :: forall a. [Pattern a] -> Pattern a
          with cat @String
          (imported from ‘Sound.Tidal.Context’
           (and originally defined in ‘Sound.Tidal.Core’))
        fastCat :: forall a. [Pattern a] -> Pattern a
          with fastCat @String
          (imported from ‘Sound.Tidal.Context’
           (and originally defined in ‘Sound.Tidal.Core’))
    ...   
```

This can be super useful! (It is the more useful, the more expressive our types are.) For all of this, the price we have to pay is adherence to the host language’s concrete syntax. We also have to adhere to the type system, but that’s not a tax, that’s a benefit.

On the other hand, if we just want to sequence some events, the “syntax tax” is quite inconvenient, as we need to write out the cat operator, the parentheses, and the commas.

We can avoid all of this by using Tidal’s concrete mini-language.

But this also comes with a price: all the support of the host language is now gone. Ghci cannot type-check parts of strings, it cannot suggest completions. Well, some customized editor might suggest completions of instrument and operator names just by string matching, so the level of support is reduced down to the purely syntactic level that’s typical for languages that are missing a static type system.

And we also lost the ability to define abstractions. Consider this example: You have developed a nice pattern, say,

```haskell
"bd [sn sn] [bd ~ ] [~ sn]"
```

and now you want to abstract over the instrument “sn”, because you want to replace it with something else. Using the host language, you would just turn a constant in to a parameter of a function, but obviously, this does not work:

```haskell
f = \ sn -> "bd [sn sn] [bd ~ ] [~ sn]"
```

The main counter argument to this complaint is that we always have the choice of using the concrete language, or the embedded one, as we see fit.

### Embedded DSL vs. Concrete Syntax: Substitutions

In fact, there are functions like `ur` that provide sort-of-lambda-calculus for the surface language. (I guess `r` stands for “replace”, more documentation at <https://tidalcycles.org/index.php/ur>)

```haskell
ur  :: Time
     -> Pattern String
     -> [(String, Pattern a)]
     -> [(String, Pattern a -> Pattern a)]
     -> Pattern a
```

The second argument is a pattern whose values are pairs `(f,p)` of names, written `“p:f”`, where `p :: Pattern a` and `f :: Pattern a -> Pattern a`. The next arguments are a replacement map for names that denote patterns (“p” in the example), and a replacement map for names that denote functions from pattern to pattern (“f” in the example).

```haskell
ur 1 "a b a" [("a", s "sn"),("b", s "bd bd")] [] 
(0>⅓)|s: "sn"
(⅓>½)|s: "bd"
(½>⅔)|s: "bd"
(⅔>1)|s: "sn"

queryArc (ur 2 "a:f a:g" [ ("a", run 2) ]
                         [ ("f", id),("g",rev) ])
     (Arc 0 2)
[(0>½)|0,(½>1)|1,(1½>2)|0,(1>1½)|1]
```

So, this is a re-implementation of some parts of lambda calculus (substitutions of values, named functions, but no lambda expressions). I don’t fully understand the semantics, e.g., why doesn’t the following have “bd” at each quarter?

```haskell
ur 1 "[a b a, b b]" [("a", s "sn"),("b", s "bd bd")] []

(0>⅓)|s: "sn"
(⅓>½)|s: "bd"
(½>⅔)|s: "bd"
(⅔>1)|s: "sn"
(0>½)|s: "bd"
(½>1)|s: "bd"
```

probably because the implementation contains magic (a call to `rotR`).

In all, this aspect of Tidal’s stringy surface language exemplifies the general observation that if a language does not contain the lambda calculus, it will invariably appear later, often incomplete, in some form or other - because abstraction (using names to denote something) is just really really useful in general, and thus fundamental for programming.

## Note on represeting patterns (queries)

We have seen that a pattern is an element of a Reader monad, so it is a function (applied to current time). So, all transformations on patterns, e.g., fast, slow, shift (<~), construct functions from functions. Nesting of these could be prolematic for efficiency, as we are creating stacks of subprogram calls, which we have to evaluate each time.

It seems to me that all transformations of time are linear (certainly the above examples are), so they could be reified: represent the linear function f : Time -> Time by its coefficients a, b in f x = a * x + b, or in matrix form [[a,b],[1,0]]. Then, composition of reified functions can be computed just once (as matrix multiplication) and their application always has the same low cost (one multiplication, one addition). The same thing is done in computer graphics, for efficient handling of nested co-ordinate transforms.

Now, for Tidal, functions might actually be piece-wise linear, so the reified represenation needs a sequence of linear functions, which could be prepresented as a decision tree. But then another potential source of inefficiency is that the size of this representation may explode unter transformations and operations.

## Note on Time

```haskell
type Time = Rational
```

We see that time uses exact rational arithmetic. The reason is that we want to treat (nested) polyrythms correctly (including thirds, fifths, etc.)

Challenge: construct a denial-of-service attack: use (nested) pattern combinators that will produce huge numbers in the denominators. Note: these are represented as Integer (not Int = machine numbers), so they will not overflow (unless your RAM overflows), but processing time depends on their size. Implementation uses GMP, which is highly optimized. So, this is rather hypothetical. But you can brush up your elementary number theory. And anyway, a successful DOS attack would just hurt yourself.