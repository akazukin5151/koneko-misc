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


# Python: Why not use type checking?

* `list[int]` is not allowed, need to use `List[int]`, which is ridiculous. No liguistic languages that have different upper/lower-cases can completely change the meaning of a word by just its case (also why I support case-and-style-insensitivity in Nim).
    * Flake8 fails your builds if you type `'list[int]'` (as a string) anyway, even though it does not cause an error in Python whatsover. Flake8 is doing what type checkers should be doing
    * Silencing that warning in flake8 also silents the entire warning for 'undefined name', which *will* crash your program. So flake8 stops your build for something that may or may not crash your program, and if you don't want it to pay attention to those that doesn't crash your program, you have to litter `# pylint` comments all over, or disable the entire check and risk your program crashing from actual undefined names.

* `from typing import ...` in every file is very annoying. Imagine needing to import the `int` class to use integers, and `import list` to use lists in the language! Or needing to use `import for` to use for-loops and `import def` to define a function! Perhaps it might be "too confusing for new players", so just make the type checker automatically stick `from typing import *`
    * Q: But what if it shadows another name? A: You shouldn't define names with the same name as Python builtin classes anyway
    * Q: but eXpLiCiT iS bEtTeR tHaN iMpLiCiT! A: Python does a lot of things implicitly, such as returning None for every function that doesn't return anything; or implicit string join with `'hello''world'`; or overloading the mathematical operators to work on any combination of ints and floats. So why does `List[int]` have to be explicitly distinguished from `list[int]`? Should we also explicitly `import for` to show that we will use a for loop? Bear with me, "explicit is better than implicit" is good, but it is not a good enough reason to object against a change by itself.
    * Q: for loops, function definitions, and lists don't need to be imported because they are language features. A: type annotations are a language feature since 2014. Many users, from casual to enterprise, see type checking as an invaluable tool. So why make this feature a second-class-citizen, only usable with imports? Perhaps the core team wants to prove that Python will always be dynamically typed, and will "never make type hints mandatory, even by convention", so they crippled it to be ugly and unusable without imports. At that point, just remove type hints and go back to comments (mypy works on Python 2, so removing type hints doesn't mean removing type checkers). Either stick to being fully dynamic, or make type hints first-class-citizens and not half-ass it *(nb: 'class' here mean 'first class train car' not 'functions are first class')*

* I don't want to define `T = typevar('T')` to appease the type checker. I don't want to spend a single line of code doing any typing-related imports or assignments. The type checker should figure that out for me!
* `foo: int = 2` as a separator for variables sucks. Julia's `foo::Int = 2` is superior. I keep reading "foo is assigned to an int is assigned to 2", instead of "foo, an int, is assigned to 2". The usages of `:` includes: to start an indentation block, slicing, and in dictionaries...
    * For `:` to start indentations, it is a muscle reflex to type the colon then press enter immediately. Using the same colon to annotate types breaks this pattern.
    * Slicing syntax is honestly not very readable, compare to Haskell's range syntax:
        * `0..2` to count from 0 to 20 inclusive, versus `0:2`, with the colon implying the word "to"
        * `0,2..20` to count with step=2, versus `0:20:2`, with the first colon implying the word "to" and the second colon implying the word "step by" (???)
        * `10,8..0` to count down by step=2 from 10 to 0, versus `10:8:-2`
        * `::-1` meaning "reverse", where the colons just mean "the start and end values are missing"
    * The colon separates the key and value in a dictionary, both of which are 'significant' in Python (compared to 'insignificant' types that are ignored by Python). Using a colon to separate a significant name and an insignificant type breaks this pattern.
* `list[int]` (without quotes), and pretty much any type annotation is finally allowed with PEP 585 (`from __future__ import annotations`), but...
    * None of the type checkers I've tried (mypy, pyre, pytype) support PEP 585 
* I *am* spoiled by static typing guarantees from compilers in statically typed languages, but I'm extra spoiled by the rust compiler to handle things for me


# My opinions on OOP:

**TLDR:** Use the [template method design pattern](https://en.wikipedia.org/wiki/Template_method_pattern)

* Avoid encapsulating data and behaviour together.
    * The classes in data.py solely handles storage and manipulation of data requested from pixiv, with completely pure functions/methods. 
* For me, using classes serves only two purposes: let other functions directly call a behaviour, and to reduce code duplication/enable code reuse. Nothing else.
    * The prompt functions can call methods upon user interaction. Code duplication between the two gallery modes (1 & 5), and the two user modes (3 & 4) is reduced.

* **Avoid modelling real world objects and nouns to avoid the circle-ellipse/square-rectangle problem; model behavior instead**. Aim for code reuse by **extracting common behaviors out**. For example, if procedure X has subroutines A -> B -> C -> D, and procedure Y has subroutines A -> B -> C -> E, then their abstract base class would contain *behaviors* A -> B -> C. X and Y will both inherit from the ABC, then define their D/E method separately (in other words, **child classes should add functionality, not remove them from the base class**). So, use inheritance only for code reuse. Instead of modelling a "is-a" relationship, **inheritance should model "has behaviour" relationship, which means composition is better most times**. Of course, this can be simply done with functions instead of classes. Use good judgement.

* **Avoiding inheritance deeper than two levels max also avoids the diamond problem and mitigates the fragile base class problem**. Never use multiple inheritance for inheritance; mixins are fine, but prefer composition over inheritance, and functions for mixins with no state. Child classes should only offer minimal extensions to their base classes just to reflect the different nature of their modes.
    * The classes in ui.py must only contain behaviour, while state is stored in the classes in data.py and their data manipulated with pure functions.
