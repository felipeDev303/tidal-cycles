# TidalCycles Adventures

## Introduction

This tutorial started as notes to myself when I tried to learn and play with TidalCycles an open source live coding environment for creating pattern based sounds and visuals. My notes grew, while I worked through Tidals documentation and other tutorials, but my knowledge didn’t, because my learning was superficial. Tidals documentation is (was, checkout the new documentation) also a bit fragmented and since you learn a topic best when you need to show and explain it to others in a comprehensible way, I decided to convert into a hopefully helpful and interesting primer to get into TidalCycles and may be even a bit more. This is meant as a living document and feedback, additions and corrections are always welcome. Please also note that all described procedures and recommendations are without any guarantee.

## Tidal Cycles

TidalCycles (Tidal) is a live coding environment and domain-specific open source mini language embedded in the programming language Haskell. It offers a unique way to interactively live code, compose and improvise not only sounds, rhythms and music, but anything that understands MIDI or the Open Sound Control (OSC) network protocol.

TidalCycles was initiated and developed by Alex McLean and is inspired by the work of Bernard Bel, Laurie Spiegel, Adrian Ward . It follows a unique concept and was originally designed for polyrhythmic, grid-based music, influenced by Laurie Spiegels “Manipulation of musical patterns” and the Indian tabla rhythms. As the name indicates - besides pattern, cycles play an important role in its concept as the basic time unit, which we will learn in detail in a later section. In its latest version it still focusses on pattern and cycles but now uses a flexible, functional reactive representation of them and offers a vast amount of pattern, time, synth and sample manipulation functions.

Tidal runs on all major desktop operating systems and is available as an IDE Plugin for the common free IDEs Atom (all platforms), Emacs (Linux) and unofficially Microsoft Visual Studio Code (Mac, Win), where it provides an interactive code playground with. By default the plugin provides, 16 OSC connections to Supercollider and the SuperDirt Synthesizer. Any Code can be directly evaluated and executed in the IDE with immediate compiler feedback so that the code and the music or visuals can be manipulated in realtime. You can save your code in the `.tidal` format and reopen and use it again at any time.

## Installation

A lot has happened since the first publication in 2019 and Tidal has completely reworked its homepage and documentation as well as its installation process, so I removed this section completely. Just follow the steps for your OS discribed in the documentation and you are ready to go.

## Configuration

By default TidalCycles provides 16 connections to SuperColliders SuperDirt Synthesizer, which is specialized on Sample manipulation but also contains some basic synthesizer functions and can be extended individually. SuperDirt is by default configured to play stereo but more outputs can be added easily. I am currently using it with six outputs but it can be any number.

Besides SuperCollider you can communicate with any any receiver which understands OSC or Midi, which includes nearly all common Audio and a lot of Video applications. For the sake of simplicity I stay with Supercollider and SuperDirt in this tutorial and add some information on this in the “Make Tidal yours” section.

## Launching Tidal the first time

If the installation was successful and you launched SuperCollider and your IDE you can create your first tidal file and save it by using the file extension .tidal. The code gets automatically the Haskell syntax highlighting. As soon as you type and execute the first tidal code, Tidals interactive GHCI compiler launches and starts sending to SuperCollider. If your SuperCollider has not been started yet, you will get an error message in the IDE console.

Evaluate `tidal_version` with `cmd+enter` and tidal prints the version to the IDE console. Let’s start to create the first basic pattern.

`d1 $ sound "bd"` and hit `cmd+enter`, or `ctrl+enter`. If a bass drum is playing now exactly on time a second, the installation and setup went well and you are ready to go.

Let’s add a second event. `d1 $ sound "bd bd"` `cmd+enter` and make it a bit more complex by changing the line as follows:

```haskell
d1 $ every 8 (0.25 <~) $ sound “bd hh:8*2 bd hh:8" # gain "1 1.4 1 1.4" # pan "0.5 0.1 0.5 0.9"
```

`cmd+enter`

All in one line, we will learn later how to write it with line breaks and what all of this means. Create two new empty lines and evaluate `hush` in the second line to stop.

This looks quite new and unfamiliar doesn’t it? Especially if you are used to imperative or object oriented programming and new to live coding it is a bit terrifying at the beginning. At least it was for me and it really took me a while to get into this. And here is why…

## Functional programming in Tidal with Haskell

Tidal is based on Haskell, a modern functional programming language. Functional programming is quite different to other programming paradigms like Object Oriented and Imperative Programming. It is not needed to learn Haskell to play with Tidal, but it helps a lot if you want to dig deeper and extend Tidal with your own functions and features. Anyway, there are some bread & butter elements in Tidal which are coming from Haskell and can make your life quite hard at the beginning to get into Tidal, namely the functional programming paradigm of Haskell and a mysterious `$` symbol.

### The world as a function

In functional programming languages basically everything is a function in its mathematical sense and thus has a much stricter definition than functions in other programming paradigms. Here, functions are pure, which means, that they do not have states nor side effects in other words, they only take care about one problem at once and return its one and only solution. Since they don´t have states, there is no iteration and all problems are solved recursively. They are usually strongly typed and nearly every modern programming language, including Python and especially JavaScript have at least some functional programming features. There are many more differences and it needs some unlearning if you are used to the other programming paradigms. But I think it is worth the effort since it really improves your programming and problem solving skills.

All of this also applies to TidalCycles and at the beginning it seems to be strange to code without variables, if statements and for loops. Tidal solves this in the functional way and there are many functions that solve these problems in a very different and interesting way. As a consequence it also makes you think different about music, scales, rhythm and composition and with this it even improves your musical skills.

This might sound a bit scaring and it is perfectly fine if you don’t care about it and just learn TidalCycles and use it to make some musical experiments. The next specialty which is inherited from Haskell, you need to get use to, is the `$` symbol. You will use it in Tidal nearly all the time and its understanding is essential.

### The `$` (and the `#`) function

Like everything in Haskell, the$operator is a function and has two inputs, one on its left side and one on its right side and one output. It is called infix operator, since it is placed between two operands and passes the input from the right side to the function on the left side. As a consequence the input on left side must be a function, the input on the right side can be any parameter which the function on the left side accepts. With this,$is basically a replacement for parenthesis. Its output is the result of this operation which can be used in another function again. As you read parenthesis from innermost to the outermost as its order of execution, you read the $ from right to left.

As an example, the function `sound` (or short `s`) takes a pattern of type string and turns it into a pattern of control maps containing synthesizer control messages.

```haskell
sound $ "bd hh arpy"   -- could also be written as
sound ("bd hh arpy")   -- or even shorter,
sound "bd hh arpy"
```

we can apply a pattern that matches the functions type signature directly since - mathematically spoken - f $ a is equivalent to f a.

All three ways do the same and apply the "bd hh arpy" pattern to the sound function. In this simple case we would use the shortest version sound "bd hh arpy". So why use the $?

It becomes useful when your code becomes more complex and you want to compose several functions without ending in parenthesis hell. Parenthesis denote expressions and it is absolutely ok, if you favor parenthesis over the `$`. It might become more obvious in the next example. Again all of these notations are equivalent:

```haskell
d1 $ sound "bd hh arpy"
d1 $ sound $ "bd hh arpy"
d1 (sound "bd hh arpy")
d1 (sound (("bd hh arpy"))
```

You decide!

The most common in Tidal is again the first one `d1 $ sound "bd hh arpy"`

So what´s going on? First the "bd hh arpy”pattern of strings is handed to thesoundfunction. Its resulting sound control pattern is handed over to the functiond1which turns the pattern into an IO Stream and sends it to Supercolliders SuperDirt, or whatever you configure as an output target.

The value of the `$` becomes even more obvious in the following, a bit more complex example:

```haskell
d1 $ fast 2 $ rev $ sound "bd hh arpy"
d1 (fast 2 (rev (sound "bd hh arpy")))
```

Tracking all the brackets becomes more difficult and with each spent $ we save one ) ! This is actually a really short code and usually your compositions will later take several lines of code. Again,sound converts the string pattern "bd hh arpy"into a sound control pattern and the last $ gives the result to therevfunction and its result is the handed over to the fast function, where it is applied together with the second argument 2and its result is finally handed over to d1.

If you simply would leave out the `$` like in

```haskell
d1 sound "bd hh arpy”   -- (error!)
```

the compiler would throw an error, since d1 expects one control pattern but seems to get two arguments instead, namelysound and the string pattern "bd hh arpy”.

For the Mathematicians amongst us the following notations are equivalent:

Mathematically `f(g(hx))` is in Haskell `f$g$h$x`

`x` is applied first to the function `h` the result is applied to function `g` and this result is again applied to `f` which gives us the final result of these three composed functions. This is how the composition of functions works in Math and in Haskell or any functional programming language and thus in TidalCycles.

### The `#` function

The `#` function works similar, but is specialized on pattern only and merges pattern on the right side of the # with pattern on the left side into a new pattern. So instead of a parameter on the right and a function on the left which are needed for the $ operator, we need a pattern of same type on both sides of the # . Hence all the # functions need to be applied before the patterns are converted by the $ function to sound control patterns.

Other Operators like `|+|`, `|-|`, `|*|`, `|/|` work in a similar way but differ in the way how they compose these pattern. We will learn more about it in the later sections. Back to Tidal for now.

## Before sound there was silence

Before we get loud we learn how to create silence and I recommend to memorize the different ways to stop sounds. We saw the `hush` function already at the beginning and that it stops all patterns from playing. Sounds that are triggered already will not stop immediately and play until the end of the sample.

```haskell
let panic = do hush
               once $ s "superpanic"
```

Type this code with the exact indentation (important!) and execute the code. From now own you can executepanic to stop all patterns, sounds and samples immediately. There is one caveat: you need to do this everytime you start your IDE and load your file. But we will learn later how to extend TidalCycles so that this is not necessary anymore.

If you want to stop just one output, e.g. `d1` you can use the `silence` function. It works similar to `hush`, but just for the according channel, all other channels continue playing with `d1 silence`. Execute your musical code to restart all sounds again.

There is still another function `solo` which works a bit different and does the exact opposite of `silence`. It mutes all other channels except the one handed over to the `solo` function, e.g. `solo 1`. mutes all channels except `d1`. `unsolo 1` reverts this again. Unfortunately we do not see which channel is muted so keep your code that muted the channel or otherwise you might find yourself testing all 16 in a worst case of forgetting which channel you soloed.

## Live code evaluation

Tidal evaluates and executes every line of code or blocks of code individually. It is in uses ghci the interactive mode of Haskells ghc compiler, which provides an immediate feedback to your evaluations.

Tidal recognizes a single lines or separate blocks of code at at least an empty line between each code line or block. If you navigate the cursor into a line or block of code and hit cmd+enter (ctrl+enter, depending on OS and IDE) this line or block is executed immediately.

Try dd1 $ sound "cp:1(5,8)" cmd+enter
and then hush cmd+enter, as soon as you start to get annoyed. Don´t forget the empty line in between.

If you want play sounds in parallel just add another connection. Again, keep a blank line between each line of code land hit `cmd+enter` after each line.

```haskell
d1 $ sound "bd(5,8)"

d2 $ sound "bass*8"

d3 $ sound "arpy(3,8)" # speed (irand 12)

solo 3

unsolo 3

hush
```

You can use up to 16 connections simultaneously. We will learn later how to layer sounds in just one connection., so that we have a lot of room for creating complex musical structures. We can mute or solo each output indvidually. solo 2 mutes all connections except d3 and unsolo 3brings them back. To stop a connection execute d3 silence You can bring it back by simply executing the d3code again. And hushto stop all of them.

Keep in mind, that long samples don’t stop immediately and might take a while. Also keep in mind that if you use long samples and fire them very quickly, which can easily happen with one Tidals functions, that Supercollider might get to its limits since there is no limit how many samples each output plays. It simply sends them to Supercollider/SuperDirt who tries to play the. We will learn more about that in the Optimization section.

## Sound and sample organization

We learned already what `d1`, `$` and `sound` do and also a little bit about pattern, but what are these strings inside the pattern next `sound`? `"cp:1(5,8)"` are the identifiers of the samples that should be played by Supercollider, respectively the SuperDirt synth, which is Tidals default synth.

SuperDirt uses samples which are organized in a folder structure and every sound name in Tidal corresponds to a folder name in this folder structure. Each folder can contain as many samples as you like and "cp:1(5,8)" identifies in our example: play the second file in the folder cp. If you want to play the first sample inside a folder you can simply skip the file number behind the sound name, here"cp:(5,8)". This is a bit confusing at the beginning, but you quickly get used to it.

The files in each folder can be named as you like, but keep in mind, that it is the alphanumerical order inside the folder which defines the order of the sounds. If you want to use your own samples I recommend to define clear folder names and concisely organize your files inside these folder by numbering them in a meaningful order , e.g. 00myfirstsound.wav 01mysecondsound.wav(or ogg, mp3, aiff), especially when you collect the same sound in different variations, or sets like drum sets in one folder. But for sure sometimes it is nice to keep them completely random to surprise yourself.

You can add your own folders to SuperDirt by following this guide. I really recommend it because Tidal and your sounds and music and sound aesthetic becomes much more individual, personal and much more interesting with this.

## Tidals Cycles

It is essential to understand the concept of cycles. Unlike other music tools and sequencers time is not measured in beats per minute (bpm) but in cycles per second (cps). But what is cycle? A cycle is the main loop that starts running and counting in the set speed, as soon as you start playing your first sound. Since Tidal counts every cycle, you can use its number in functions, e.g. to trigger certain events every nth, odd or even cycle as we will learn later.

- `setcps 1` sets the cycle speed to one cycle per second.
- `resetCycles` sets the cycle counter back to 0

You fill cycles with musical or control events by using patterns, e.g strings such as "bd bd". As we learned already the function sound takes this pattern and converts it into a control pattern which is then sent by the connection d1to Supercolliders SuperDirt Synh to play the according sample.

d1 $ sound "bd bd"plays the bd sample 2x per cycle, hence 2x per second which means 120 times per minute (120 bpm) if we set the cycles cps to 1. If we put more sounds into the cycle, we keep the cycle speed but raise the bpm. d1 $ sound "bd sn bd sn" doubles the bpm since we doubled the number of sounds in the pattern. What can we do to slow it down again?

We are not restricted to use only one cycle but can use functions to expand pattern over several cycles or compress them into one cycle.

```haskell
d1 $ slow 2 $ sound "bd sn bd sn"
```

stretches the sounds over 2 cycles or bisects the bpm. The function `fast` does the exact opposite and

```haskell
d1 $ fast 2 $ sound "bd sn bd sn"
```

doubles the speed and squeezes the `"bd sn bd sn"` pattern 2x into one cycle. There are many ways to achieve composition and pattern manipulation over time.

## What is a pattern in Tidal?

There are many definitions of pattern. In Tidal, you guessed it, it is a function which parses strings it gets handed over into events over time. By default the time span, or better “time arc” - since we think in cycles in Tidal and the notion of time is cyclic - is one cycle. The pattern function parses "bd sn bd sn" into 4 separate events and spreads them evenly over the time arc of one cycle. In return you get back the active events which can be handed over e.g. to sound. You can visualize this by executing the following code in your IDE: "bd sn bd sn" :: Pattern String which returns the time arc of each event in the console:

```
(0>¼)|"bd"
(¼>½)|"sn"
(½>¾)|"bd"
(¾>1)|"sn"
```

Since we have four events in our pattern, the time span for this pattern is divided into quarters. If we would have 3 it would be 1/3, 5 with 1/5, you get the gist. The first `bd` is active in the first quarter of the time span `(0>¼)`, the second `(¼>½)` in the second and so on. I guess you can imagine what rhythm this pattern creates with the bass drum on 1 and 3 and the snare drum on 2 and 4.

What we also can see is that Tidal uses ratios and not seconds or milliseconds for the representation of time for the arc of the event, which is a more musical representation, since we use them in music everywhere. So the occurrence of an event is represented more in a functional way in its mathematical sense in a precise ratio of two integers instead of a float.

## Anatomy of a pattern

This also means that time in Tidal is rational and represented in ratios, hence the type of Time in Tidal is defined as `Rational`. If you check Tidals pattern module line 24 ff you will find the according type definitions.

```haskell
-- | Time is rational
type Time = Rational
```

A pattern relates to an arc of time with a start and an end point which both are of the rational type Time . An ark is not a fixed point of time but a time span sitting somehow fluid in time at 1/4 of a cycle with an end at 3/4 independently from where we are currently in real time.

```haskell
-- | A time arc (start and end)
type Arc = (Time, Time)
```

A very functional or mathematical definition again is Tidals Type of a part of an arc which is defined by the whole and the part itself, which implies that the a part needs to fit into the according whole. If the part and the whole are equal, the part is the whole, hence there is only one single part, e.g. "bd” in d1 $ s "bd" which plays one time every cycle.

```haskell
-- | The second arc (the part) should be equal to or fit inside the
-- first one (the whole that it's a part of).
type Part = (Arc, Arc)
```

Since pattern represent events in a time arc we need another Tidal specific type, the type Event. An event is described by a part and and a value of type a . With part, each event has its own time arc and Type a simply means that it basically can be any type, number, strings, even other pattern but they can not be mixed in one pattern. The letter a is just an arbitrary identifier. Naming variables with just one letter has its origin in the mathematical roots of Haskell and functional programming. Variable names don´t carry any semantics in its name and are just an identifiers. This makes it harder to learn at the beginning, but it is very efficient and you quickly get used to it.

```haskell
-- | An event is a value that's active during a timespan
type Event a = (Part, a)
```

In Tidal pattern can also receive external events from a Midi Controller or other Software and this is reflected by the new data type State, which combines an Arc as a time parameter and a ControlMap for the received controller data for this time arc. Again, an arc of time does not represent a point in time, but a time span. This refers to the psychological concept of the specious present, and the phenomenal duration of an experience.

```haskell
data State = State {arc :: Arc,
                    controls :: ControlMap
                   }
```

The Query function glues it all together and takes states and outputs an array (indicated by the square brackets) of the combined events. Many events can take place at the same time, since tidal supports polyphony, all of them with its individual arc of time. They have its own start and end and may not overlap at all. If the time arc of an event is outside the arc in the query state it returns the part of an arc which is the intersection of the arc of the query and the arc of the event.

```haskell
-- | A function that represents events taking place over time
type Query a = (State -> [Event a])
```

In Tidal any pattern can be interpreted as discreet/digital or as continuous/analogue values. The discreet interpretation of a pattern is useful for discreet events, like notes or sounds and the continuous interpretation is useful for filter sweeps or any parameter that should change smoothly. To differentiate between both it contains the data type data Nature. The pipe symbol | denotes that its either Analog or Digital.

```haskell
-- | Also known as Continuous vs Discrete/Amorphous vs Pulsating etc.
data Nature = Analog | Digital
            deriving Eq
```

The Pattern datatype consists of an either digital or analogue nature, plus a query for calculating events for a particular timespan.

```haskell
-- | A datatype that's basically a query, plus a hint about whether its events
-- are Analogue or Digital by nature
data Pattern a = Pattern {nature :: Nature, query :: Query a}
```

The pattern module also contains a type `ControlMap`, a dictionary which maps (or stores) name (of type String) and value (of type String, Double, Integer) pairs, including external control values from the State datatype.

Finally the pattern module returns a Pattern of type ControlPatternwhich is of the type ControlMap

```haskell
data Value = VS { svalue :: String }
           | VF { fvalue :: Double }
           | VI { ivalue :: Int }
           deriving (Eq,Ord,Typeable,Data)

type ControlMap = Map.Map String Value
type ControlPattern = Pattern ControlMap
```

Note that these are only the function type signatures of the types used inside the pattern module, not the functions itself.

## Variable and function type signatures

By executing `type:` or short `t:` you can find out the type signature of every type and function. It tells you which type of data it consists of or understands at its inputs as well as what it returns at its output.

Try and evaluate :t 'a' and the compiler will tell you in the IDE console that it is of type Character 'a´::Char , or a string :t "Hello World!" which is a list of characters "Hello World!"::[Char]. The brackets around char indicate the list. t: Truewhich, you guessed it, is of type boolor just combine them (True, 'a') which will return (True, 'a')::(Bool, Char). When you try it with a number, e.g. 1 you get something different 1::Num p => p . We will learn later what the fat arrow means, but our Number 1is of type Num, Haskells type class for integers. Or 42.1 is a real or fractional number hence the compiler will return the fractional type class
42.1::Fractional p => p.

With t: sound for example the compiler lets you know, that the function sound accepts sound::Pattern String->ControlPattern which means that it takes pattern of type string as input and will output a control pattern. It takes a string typed pattern like "bd" or "bd hh arpy" (always written in quotation marks) and hands over the ControlPattern to the $ function which applies the it to d1 , rev or fast and so on.

fast:: Pattern Time -> Pattern a -> Pattern a takes two pattern, Pattern Time which contains the times fastshould apply and a second pattern which can contain any type and is the pattern these times should be applied. fastthen returns the speed up pattern with the time pattern applied.

d1 $ fast "2 3 4" $ sound "bd sn arpy"

In signature of the function every we can see that functions can also accepts functions as input. These kind of functions are called Higher-order functions.

every :: Pattern Int -> (Pattern a -> Pattern a) -> Pattern a -> Pattern a
It takes a pattern of type integer (whole numbers), a function which is denoted in brackets and a second pattern of any type and returns a pattern of that type. (Pattern a -> Pattern a)is the accepted type signature of the function that we can hand over as input. The ais a type variable which, as a convention in Haskell, denotes that it can take any type. Means, if you see single characters in a signature it is a convention, that they are used for polymorphic types which can become any type but this type then needs to be the same for all occurrences of the ain the signature.

For example the type signature rev matches rev :: Pattern a -> Pattern a and takes a pattern of any type. In this exampled1 $ rev $ s "bd sn arpy” it take a ControlPattern from s so the type of the argument rev takes in in this case is set to ControlPattern which means that it will return a result of type ControlPattern, since argument and the return use an a in the function signature. The result is handed over to d1by the $operator. d1accepts ControlMaps as an argument and we know already that ControlPattern are of type ControlMap.

Another example with a list of integeres and the above function fastas an input
d1 $ every "3 5 7" (fast 2) $ sound "arpy*4"
It has a slightly different signature and always needs to be evaluated in round brackets first like so(fast 2). This also returns a Pattern a so everything is fine.

Finally, if we check the type signature of the function that creates our pattern. With t: "" we get "" :: Data.String.IsString p => p :: Data.String.IsString p => p which looks quite different. Data.String.IsStringis a type class in Haskell that denotes strings written in quotation marks, which our patterns are. p is an arbitrary “math style” identifier and could be any letter. p => p the fat arrow denotes, that p is constrained and needs to be an instance of Data.String.IsString.

The signature takes the content inside the quotation marks and returns them as a “string-like” data. While the ->is called a type constructor the fat arrow => denotes a type constraint. In other words it only works with functions that accept this type. That is the reason, why everything you feed into functions that take pattern as input (like sound) needs to be enclosed in quotation marks "" .

So for the debugging of your code and when you are not sure why a code construct does not work, check the signatures and if a function can handle the type you want to feed in.

## Different functions for different purposes

Tidal contains a plethora of functions to manipulate pattern, time and sounds. Not all of them are by default compatible by its signature or purpose as we learned already. We can differentiate the following categories

Control Functions turn patterns of strings or numbers into control patterns with the purpose to send control messages to sound generators, like the Supercolliders SuperDirt Synthesizer. Audio control functions like gain or pan, which manipulate the volume or the position of a sound, sample manipulation functions like striate which cuts samples into short grains or audio effects like delay which initializes SuperDirts delay.

Higher order functions accept functions among its inputs. Since patterns are functions themselves actually all functions that work with pattern are of higher-order. But here we mean it in a stricter way and refer to functions which accept functions of the other function categories as input. The function every can be used to apply another function to a pattern every nth cycle. Or jux adds a function to a pattern but only on one channel. weaveWith weaves a list of functions into a pattern for rich complex pattern.

Functions for randomness and chance bring controlled uncertainty and noise to your compositions. Some of them, like `randcat` or `shuffle` can be used best to rearrange pattern in a random way, others are better in manipulating time arcs like `sometimes` or `SomeCycles` or events like `degrade`. Some can be used to randomly pick elements from lists like `choose` or or create random numbers that can then be used in other functions `irand` or `rand` or even perlin noise a smooth “organic” noise function which perfectly works on analog-alike control functions of sound effects like the lowpass filter and resonance.

### Time manipulation functions

Functions like `brak`, `rev`, `palindrome` or fast and its opposite slow manipulate the time arc of a pattern by reversing the events inside the pattern, slowing them down by stretching the over several cycles or speeding them up by compressing them into one cycle. There a special functions for shifting time like `<~` or `~>` which shift pattern back and forth in time.

### Transition functions

Transition functions like the `jump`, anticipate or xfade provide different ways to transient between the current pattern and the next pattern, either in an abrupt or smooth way. To smoothly transient between single values you can use the function `smooth` which smoothly interpolates between rational or floating point values in a pattern.

### Generative functions

Tidal provides even generative functions like the Lindenmayer function based on the L-System, a formal grammar to describe generative biological processes.

These are just a few and there are many more. Checkout all functions including internal and non-documented functions with its signatures. I recommend to try at least all of the documented to learn them and compose them to realize your musical vision and get new ideas

## Composing functions the right way

Tidal really gets fun when you learn how to write your patterns and manipulate and alter them by intuitively sticking functions together without being interrupted by the compiler and searching for bugs in your code. This is most of the time the case, either because of typos and most of the time because we tried to combine functions with signatures which do not fit.

We learned already what `()`, `$`, `#` do, what a variable and function signature is and that it is important that they need to fit, when you use them together. We know that `$`, `#` are functions, so they have signatures, too. You get their signature by evaluating them in brackets `:t ($)` and `:t (#)`

```haskell
($) :: (a -> b) -> a -> b
```

`$` accepts two arguments, a function denoted by the (a -> b) and a second argument aand returns a result of typ b. A character like aor b in a signature is used to denote, that this argument can be of variable type, it can take any type. When we have two type variables like in the above example this means that both are independently variable and don´t need to be the same.

```haskell
(#) :: Unionable b => Pattern b -> Pattern b -> Pattern b
```

`#` takes two Pattern as arguments, bound to the same type Unionable. The Unionable is a class defined in Tidals core module and used for all types that support a left-biased union ,which is a Haskell function used to merge two lists. Here these lists are our pattern. Left biased means, that the elements of the first argument (list, pattern) are always preferred to the argument of the second argument (list, pattern). The fat arrow => denotes that both arguments are bound to this class. From our practical exercises we know, that we can only combine pattern of the same type from the right side of the #to the left side and now we know why.

So how do we combine and stick them together in the right way? Simply by taking care that all signatures of the functions and types fit together and by following some simple rules depicted in the following example.

```haskell
d1 $ slow 4
   $ spaceOut (map (1/) [1, 1.2 .. 10])
   $ sometimesBy 0.66 (rev)
   $ rarely (juxcut(# speed (choose[0.33, 0.5, 0.66, 0.75, 1.5, 2 ]))) 
   $ sound “bd*4”
   # n (choose[1, 3, 5, 7])
   # pan (slow 4 $ sine )
   # orbit 0
```

As an exercise, check the signature of each function of the above code with :t and check how and why they fit together.

Have a function which takes a pattern of type ControlMapor a ControlPattern and sends them as IO stream via OSC or Midi, like d1, once, asap etc., at the end of the evaluation, hence the beginning of your code.
$ takes a pattern on the right and applies it to the function on the left. The result needs to fit again to the signature of the an eventually preceding function.
Similarly the # function takes a pattern to the right and combines it with the pattern on the right and returns a pattern. The preceeding function needs to have a pattern in its signature to understand the returned pattern.
If you want to use a function that returns a pattern inside a function that takes a pattern of type ControlMap, you need to evaluate it first with the bracket () notation, like juxcut (# speed 2)
Vice versa if you want to use a functions which can not be used with the # because they don´t take but return pattern inside a function that takes a pattern you also need to evaluate them first with the bracket notation ().For example # pan (slow 4 $ sine ) or # gain(choose [0.5 0.75 1])
Use Haskell functions with fitting signatures, like the below map:: (a -> b) -> [a] -> [b]which takes any function and any list and returns a list with the function applied. Since Patterns are lists this works perfectly in the example.
Always check the signatures and error messages
Rarely you see Haskells `.` operator in Tidal live code. It chains functions in way brackets would do do, but often produces a cleaner code . While the `$` operator applies the result of a function to another function and `#` pattern to another pattern , the `.` operator creates or composes a new function out of two functions right and left. As you can see in its signature with `:t (.)`

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```

It takes two functions `(b -> c)` and `(a -> b)` and returns a composed function `(a -> c)`

Or Mathematically

```
(f . g) x = f(g x)
```

We can say `(f . g) x` is equivalent to f(g x). g is applied first and then f is applied to the result. This enables us to write some kind of functional “atoms” and stick them together to more and more complex functions to solve more complex problems. Not to confuse withe Tidals Pattern . operator used inside pattern, which we will get to now later.

```haskell
-- If you want to apply room and room size you can chain them
d1 $ sometimes (#room 0.8).(size 0.9) $ s "[bd*4, ~ sn]*2"
```

## Function variations

And for the sake of completion — sometimes you find a variation of a Tidal function with a ‘ at the end of its name. The ‘ can be used anywhere in a variable name and is a valid character and it is just another math like convention from Haskell to denote a slightly different version of the original function, like fit and fit’. These variations are often more specific functions, which can take more parameters and its always worth while to look into them. If you write your own variation of one of Tidals functions consider the ‘ in its name. For example the sample grain function striate

`d1 $ striate 32 $ "bev"`, which cuts samples into a number of bits has a special version with an additional parameter for the length of each bit. Here we have 32 bits, each with a length of 1/16 of the samples length.

```haskell
d1 $ striate' 32(1/32) $ s "bev"
```

## Performing code live

Live coding is about performing code live and, depending of what you want to achieve, it is essential to organize and optimize your code in a way that you can perform and experiment in a fluid and effective way. To achieve this it sometimes helps to prepare some functions and patterns in a `let` so that you can access and use it later in your code.

```haskell
let rotate = (slow 4 $ saw )
d1 $ s "arpy(5,8)" # pan rotate
```

If you want to execute several functions at once, it is useful to combine them with the `do` function. Keep attention to the correct indentation and that we don´t need the blank line in between in this case.

```haskell
do
   resetCycles
   let rotate = (slow 4 $ saw )
   d1 $ s "bd*4"
   d2 $ s "arpy(5,8)" # pan rotate
```

`once` can be used equivalent to the d1function but does not loop the pattern it receives. This is very useful for intros, or long drone like sounds, which should only kicked off once since you can not stop sounds manually, once they were sent. Or if you want to control manually when they should play. Executing them is a little bit similar to hitting a key on a keyboard or a drum pad, e.g. withonce $ s "bd" Hold the command / control key and hit enter several times and it plays once ad immediately as you hit enter. I often use it to launch very long drone sounds, which I definitely want to be looped.

## Pattern Arithmetic

Tidal specialty are musical or rhythmical pattern. Pattern are some kind of “mini language” inside tidal which has its own parser. To get the most out of tidal it is essential to know how this parser works and how you can combine patterns quickly to more complex structures. I was confused at the beginning and it took me a while to memorize them, especially how to group correctly.

```haskell
-- [] groups a pattern. The group counts as one element in the cycle
-- Thus the group plays double the speed of the single elements 
d1 $ s "[arpy arpy] arpy"
-- . The comma notation is equivalent to the bracket [] notation
-- It belongs to the pattern parser and not Haskells . operator
d1 $ s "[arpy arpy] arpy" 
-- , Use the comma to play multiple pattern simultaneously each with
-- its individual pulse. Don´t forget the [] brackets!
d1 $ s "[arpy arpy arpy arpy, moog moog moog]"
-- {} Curly braces interpret the enclosed pattern in a different way
-- The first half of the pattern defines the pulse the second obeysd1 $ s "{arpy arpy arpy arpy, moog:1 moog:2 moog:3}"
-- * Use the * to repeat a pattern or event
-- This is equivalent to the above patterns.
d1 $ s "[arpy*4, moog*3]"
d1 $ s "{arpy*4, moog*3}"
-- or with a full pattern 
d1 $ s "[arpy*4, moog*3]*2"
-- / The exact opposite can be achieved with the / operator
-- This plays the moog sound at the beginning every 2nd cycle
d1 $ s "moog/2"
-- : selects a sample from the according folder
-- This selects the third sample inside the bd folder
-- d1 $ s "bd:2"
-- This might look confusing at the beginning but is totally valid
-- It selects sample 3 from the bd folder and divides the tempo by 2
d1 $ s "bd:2/2"
-- <> Alternates between patterns
d1 $ "<arpy moog> bd*3"
-- ? randomly removes events
d1 $ "hh*16?"
-- ! replicates a pattern with each !
d1 $ "bd*2!!3 arpy"
-- _ elongate a pattern. Equivalent to ~
d1 $ "bd bd _ _ _ _ arpy _ "
-- @ elongate a pattern. Equivalent to the above _
d1 $ "bd bd@5 arpy _ "
-- () plays Euclidean sequences
d1 $ s "arpy(5,8)
-- ~ adds a pause event
-- This is equivalent to the above Eclidean rhythm
d1 $ s "t06 ~ t06 t06 ~ t06 t06 ~"
```

## Manipulating Pattern with functions

- `sometimes` `someCycles`, `somecyclesby` etc
- `Append` `fastAppend`
- `Cat`  `fastcat` `Randcat`
- TBD `|+|`, `|-|`, `|*|`, `|/|` `~>`

## Rhythmical Patterns

Binary pattern

Example tbd

## Melodic and harmonic patterns
Tidals concept is definitely aimed to rhythmical structures but Tidal also provides all necessary functions to create harmonics and melodies.

Example tbd

## Manipulating Samples with functions

If you use Tidal with its default SuperDirt synth you can use a powerful bunch of sample manipulation and grain functions. Perfect for remixes and sound design. loopAt for example fits the sample into a given number of cycles. Cut samples into small bits and manipulate them with gap, chop, striate, off or stut. Use them especially in conjuncton with time related functions like `slow` or `fast` or with extreme parameters to achieve unique effects.

Example tbd

## Sequencing and Structure

Since Tidal is meant for live coding which is heavily based on improvisation and also has a very individual concept of time, it offers only a few functions that can be used to create “traditionally” timed sequences, or song alike structures.

The ur function is one way to create more complex compositions and allows to define “patterns of pattern” in a repeating loop. The function takes three parameters, the length of the loop, the pattern that defines the structure, or order of the fed in pattern and the fed in named pattern, Optionally you can add a forth parameter for effects. These pattern and effects need to be defined before you can use them

Example tbd
With seqP and seqPloop you can create sequences of Pattern based on the current cycle count, either once or in a loop. Tidal starts counting global cycles as soon as you play your first sound and resets it as soon as the last cycle is hush. The biggest caveat is, that the cycles loose its“fluid” property since their start and end is bound to this global cycle counter and if you miss this cycles and execute the seqP or seqPLoop too late, the pattern won´t start. If you are not sure you can reset the cycles count executing resetCycles and execute the seqP pattern code afterwards. The most convenient way is to group both in a do block. Keep attention to the correct indentation again.

```haskell
do
  resetCycles
  d1 $ seqP [ 
    (0, 16, sound "bd bd*2"), 
    (8, 24, sound "hh*2 [sn cp] cp future*4"), 
    (8, 32, sound (samples "arpy*8" (run 16)))
  ]
```

Anyway a cycle counter would be helpful, not sure if one exists and would be a nice future project. It is easy to loose overview if functions and pattern become longer, so it is convenient to assign them to a let and only use the name in seqP list.

```haskell
let firstpart = sound "bd bd*2"
    secondpart = sound "hh*2 [sn cp] cp future*4"
    thirdpart = sound (samples "arpy*8" (run 16))
d1 $ seqP [ 
   (0, 16, firstpart), 
   (8, 24, secondpart), 
   (8, 32, thirdpart)
  ]
```

## Rule based patterns

- L-System <https://tidalcycles.org/index.php/lindenmayer>
- Markov Chain <https://tidalcycles.org/index.php/markovPat>
- <https://en.wikipedia.org/wiki/L-system>
- <https://en.wikipedia.org/wiki/Markov_chain>

## Make Tidal yours

Tidal is already fun out of the box but it gets even more fun when individualize it and develop your own way of audiovisual interaction and expression. These are some starting points which I found helpful or will try out in the future.

### Create your own functions

You can create your own functions and use them in your code. To do so you can rely only on Tidals set of functions but also utilize all the features of the Haskell Programming language. In this section we will concentrate on the first and learn how to use Tidals functions to individualize and optimize your live code. In the next section we will learn how to use Cabal to externalize code into a library and how to use Haskell to extend Tidals functionality. The idea is to create a broader musical toolset to become more creative, expressive and effective when live coding and composing.

I will save this for one of the next parts, since this is beyond the scope of this introduction.

### Create your own library

Writing and importing your own library of functions is another great way to make Tidal even yours and to widen your musical expression and make your live performances more effective. You can use it for example to prepare and outsource often used combinations of functions, parameters and sounds. You just need to write it once, save it to the library and import it. After the import you can use them immediately in your code. This is a huge time saver and provides a great way to broaden the complexity and musical variety of your performance.

Again, this also is beyond the scope of this introduction and I will write more about this in one of the next parts.

### Contribute to the TidalCycles Project

Tidal has a small but vivid community and from what I read on Github and in the forum ideas and support of the development is always welcomed. Note to myself: Get your branch on Github and start to propose and develop new functions for Tidal and share it with the community or support Alex with a KoFi.

### Create your own Tidal Startup file

Usually Tidal uses its default Startup File in your IDEs Tidal Plugins folder. But you can overwrite it with your own on a project basis. Put a copy of the BootTidal.hs into your project folder next to the .tidal file with your code. From ow on it uses this file to launch Tidal when you are working with you `.tidal` file in this folder.

### Separate and Multichannel Output

By default the SuperCollider setup is set to stereo but easily can be extended to separate audio channels, e.g. to route it into your DAW or to create even multichannel output to separate speakers to pan sounds across 4 or more speakers.

While multichannel output uses only one output but to multiple channels, separate output uses multiple individual outputs that can be addressed separately by the orbit function, some kind of Tidals audio bus.
If you want to internally route the separate output into your DAW you also need an audio router like free and open source JackAudio.

### Add OSC devices

Opens Sound Control (OSC) is a popular, very fast and flexible open source network protocol for audiovisual applications and hardware. Nearly all major applications for making Music, or Live Visuals support OSC, including Applications from Ableton, Native Instruments, VDMX, Resolume, Mad Mapper, Unity3D, or Frameworks like openFrameworks, or Processing to just mention a few.

To add OSC connections you need to add them to Tidals boot file which you should copy as described above to your Project folder. Tidals description for adding OSC Targets is a bit incomplete and it took me a while to understand how to add it correctly to tidals startup file. I created a gist with the working code. It is important to use the correct indentation in Haskell and also, since Tidal is directly communicating with the interactive GHCi environment, that the code block each is in the right parenthesis :{ }: if you split it over several lines. Otherwise you get error messages in the console and Tidal does not start.

#### Basic OSC setup

```haskell
:{
let myTarget :: OSCTarget 
    myTarget = OSCTarget {oName = “myTarget”,
                          oAddress = “127.0.0.1”, 
                          oPort = 7000, 
                          oPath = “/tidal”
                          oShape = Nothing,
                          oLatency = 0.02, 
                          oPreamble = [], 
                          oTimestamp = MessageStamp }
:}
```

The first three parameters define the Name , IP address and port of your OSC target. Check the IP address of the machine your OSC target is running and insert it in oAdress. Be aware that it can change when you change the network or location, since the are usually assigned dynamically. The oPort needs to be set up in your OSC Target application and needs to be a free port on your machine. In the above example it is the local machine, which is the case, when the OSC Receiver sits on the same device. Every OSC message from tidal will be preceded by this path definition, so that it is easily identifiable and can be matched on the receiver side. I named it /tidal but this is totally up to you.

If everything is correctly set up it will send and function and parameter to 127.0.0.1, which is the local machine and port 7000. The OSC receiver application, in my case Unity3D, listens to this port and receives the OSC data like/tidal/ proceeded by the strings or values defined in oShape. Now you can match these strings or values and map them to the according function in your OSC Target Application to control it from Tidal. Since it is tedious to map and doesn´t make sense in most of the cases to send all parameters we can define a shape of the data to be sent.

A detail that I noticed was, that tidal silently fails to start, if there is no network connection and the OSC target is not on the local machine and got a lot of error messages when I tried to execute any Tidal code. This only happened when the network connection was not available. When the network was available but only the target was not running the compiler gave the correct warning and I still was able to run my Tidal code.

#### Define a shape

The `oShape` defines the shape of the data the OSC target will receive from Tidal. While theoPath is used to distinguish Tidals OSC messages from other messages the oShape defines or maps the parameters in the pattern of your tidal code to messages that the OSC target understands. These messages are actually human readable text with the parameter name and value that is matched on the receiver side and processed accordingly.

If you don´t define an oShape , Tidal sends any parameter of your patterns. From my understanding this only makes sense, if you map all parameters on the target side and actually rebuild the SuperDirt functionality on an alternative synth or if you want your visuals to react to all parameters and map them accordingly on the target side. Tidal sends named parameters in this case and each parameter will be preceded by the name of the parameter, as a string. This includes ALL parameters that are used in the tidal code, including cps, cycle, delta etc.

I think a more common case is to define an `oShape` and send only parameters which are understood on the target side. As a generic example:

```haskell
:{
let unityTarget :: OSCTarget
    unityTarget = OSCTarget {oName = “Unity”,
                            oAddress = “127.0.0.1”,
                            oPort = 7000,
                            oPath = “/tidal/”,
                            oShape = Just [(“mymessage”, Nothing)],
                            oLatency = 0.02,
                            oPreamble = [],
                            oTimestamp = MessageStamp
                           }
:}
```

The `oShape Just [("mymessage", Nothing)]` sends any pattern behind the identifier mymessage. Just is just a data constructor from Haskell and means that it takes any type.

For example: d1 $ mymessage pS "hello world" sends alternating "/tidal/" s hello and "/tidal/" s worldvia OSC with each cycle. pS is a function that takes a string and a pattern of type string and returns a ControlPattern which is then sent via OSC. If you don´t want to write ps all the time you can simply assign it like let mymessage = pS mymessage so that you can writed1 $ mymessage "hello world". I will keep it for now due to the following examples.

Similar to a string pattern pIor pF do the same with integers or doubles (floating point with double precision) if the string contains numbers. For example

d1 $ pI mymessage "1" sends "/tidal/" i 1 whereas

d1 $ pF mymessage "1" sends /tidal/" f 1.0

d1 $ pF mymessage "hello world" is ignored, since the pattern does not match a float and the function can´t convert it. But doubles are converted to integers and vice versa. E.g. 0.5 become 5 when converted from double to integer, whereas 5 becomes 5.0 when converted into the other direction. With this most generic example you can send basically anything from Tidal via OSC to control an OSC device from Tidal.

You can go further and define specific oShapes like in the example in conjunction with the Faust Noise synth. Here we define an oShape which sends any pattern behind “level” as a float and d1 $ pf "level" "0.5 1" alternating sends a "/noise/level" f 0.5 and /noise/level" f 1.0 each cycle which the Faust Noise synth understands.

```haskell
anotherTarget :: OSCTarget
anotherTarget = OSCTarget {oName = "Another one",
                             oAddress = "127.0.0.1",
                             oPort = 7771,
                             oPath = "/noise/level", 
                             oShape = Just [("level", Just $ VF 0)]
                             oLatency = 0.02,
                             oPreamble = [],
                             oTimestamp = MessageStamp
                            }
```

### Add Midi devices

I guess everybody knows the Musical Instrument Digital Interface MIDI. I tried to work with Tidal and Midi on Windows and it wasn´t really fun. I used it in conjunction with Ableton live 9 it was out of sync all the time. In my opinion, windows is not the right OS for making music. Ableton recommends stone aged virtual Midi drivers which I really don’t recommend to install. Jack Audio might be an alternative but all of them feel wonky. Ableton even crashed several times. On Mac this is a different story from what I have read but I did not try it myself on my MacBook, yet.

Anyway if you follow Tidals MIDI and MIDI Cock how to configure SuperCollider and how to write Pattern for MIDI you can use your favorite Soft- or Hardware Synthesizer, even control your digital audio workstation (DAW) with it.

## Optimizing Performance

You can easily reach the limits of SuperDirt and Supercollider, e.g. if you fire longs samples to often or use functions like striate which excessively work on your samples. If the sound starts to glitch, check SuperCollider status bar in the right bottom corner of the SuperCollider IDE window.The first number in the “Server” section is the server utilization. If it is above 100% SuperCollider starts to skip samples which manifests in glitches or even silence.

Either change, or shorten your samples, test different, less demanding parameters with functions like striate or use the function cut which cuts a sample as soon as a new one starts. This might be familiar from drumming and drum computers where an open HiHat is cut by a closed HiHat. You can use this function on any sound so that only one sample is playing at once. If you use it with a negative value, only very long samples are cut. Both methods are good for the performance, but influence the sound drastically.

Effects can bring SuperCollider to its limits too and try to share effects by using the same orbits on different outputs. Outputs that share the same orbit automatically share effects like delay or room as soon as they are added to one of the outputs with the same orbit.

## SuperDirty Tricks

SuperDirt the default synth used by Tidal is actually specialized on sample manipulation but it also contains basic synthesizers and it can be extended with your own synth definitions via Supercollider. More about this in one of the next parts.

## Resources and Links

A comprehensive list of artist, music and programming resources. Let me know, if you have additions and recommendations.

### Tidal Cycles

- Tidal Cycles
- Tidal Cheat Sheet

### Haskell

- Hoogle
- Haskell Wiki
- Learn you a Haskell for Great Good
- Monday Morning Haskell
- Haskell Cheat Sheet
- Haskell Style Guide
- Haskell ressources

### LiveCoding

- TopLap
- Livecoding Düsseldorf, Germany my home node, Facebook group

### Good reads

- Inside the Algorave movement
- Specious present

### Video Tutorials

- Learn Haskell in one video
- TidalCycles utorials by Mike Hodnick aka Kindohm