# koneko-misc

Translated data.py and pure.py from [koneko](https://github.com/twenty5151/koneko) into Nim. For fun.

## My thoughts on the languages

Language | Good | Bad | Ugly
--- | --- | --- | ---
Python | Easiest to use, looks the best | Kinda slow sometimes | Runtime errors are scary, compiler doesn't check for anything at all. Docs manage to be verbose but utterly useless, most times. Package structure is a disaster
Nim | Static type checking, small single executable binary, UFCS, looks nice too | Small community, lack of docs | Channels must be globals or use pointers to pass them. Needs better docs. The effort & time needed to optimise it could have gone to writing more Python
Julia | Like Python but has piping macros. Faster for numerical stuff | Despite it being dynamically typed, it's really statically typed *and* compiled, making it slow for a dynamic, "interpreted" language | Compiling to an executable binary takes forever
Go | Best vim integration, single executable binary, static type checking | Channels deadlocking, binary is larger than Nim | No batteries included, need to write elementary functions like lst.index(), contains(), filter(). Syntax is archaic and Verbose, less than C/C++/C# but not by much. Worse thing is that its performance was comparable to Nim's, so it was more confusing than Nim without any speed benefits.
Elixir | Functional style (pipes, recursion, immutability) looks great and flows well. Built-in actor based concurrency. | Functional programming initially needs some time to get used to, `mix escript.build` for compiling to single binary is weird, binary is larger than Nim | `icat` doesn't work, even with erlport
Rust | Memory safe, compiler actually catches errors, semi-functional feel but still imperative | No GC, compiler needs a lot of info, references, lifelines, stubborn type system, binary is quite large | High development time, verbose but feels better than Go for some reason.

Go is very opinionated, which isn't bad, but it's opinionated on relatively minor things while still being archaic in every other major thing

## One sentence summary
* Python: executable pseudocode
* Nim: C but with python syntax and batteries
* Julia: Semi-compiled Python but more flexible (both dynamic and static), faster execution, slow compilation
* Go: Better syntax than C, no batteries included like C, except for goroutines
* Elixir: impure but pleasing functional, actor based
* Rust: compiler ensures (memory) safety, references and lifelines everywhere


# My opinions on OOP:

* Avoid encapsulating data and behaviour together.
    * The classes in data.py solely handles storage and manipulation of data requested from pixiv, with completely pure functions/methods. 
* For me, using classes serves only two purposes: let other functions directly call a behaviour, and to reduce code duplication/enable code reuse. Nothing else.
    * The prompt functions can call methods upon user interaction. Code duplication between the two gallery modes (1 & 5), and the two user modes (3 & 4) is reduced.

* **Avoid modelling real world objects and nouns to avoid the circle-ellipse/square-rectangle problem; model behavior instead**. Aim for code reuse by **extracting common behaviors out**. For example, if procedure X has subroutines A -> B -> C -> D, and procedure Y has subroutines A -> B -> C -> E, then their abstract base class would contain *behaviors* A -> B -> C. X and Y will both inherit from the ABC, then define their D/E method separately (in other words, **child classes should add functionality, not remove them from the base class**). So, use inheritance only for code reuse. Instead of modelling a "is-a" relationship, **inheritance should model "has behaviour" relationship, which means composition is better most times**. Of course, this can be simply done with functions instead of classes. Use good judgement.

* **Avoiding inheritance deeper than two levels max also avoids the diamond problem and mitigates the fragile base class problem**. Never use multiple inheritance for inheritance; mixins are fine, but prefer composition over inheritance, and functions for mixins with no state. Child classes should only offer minimal extensions to their base classes just to reflect the different nature of their modes.
    * The classes in ui.py must only contain behaviour, while state is stored in the classes in data.py and their data manipulated with pure functions.
