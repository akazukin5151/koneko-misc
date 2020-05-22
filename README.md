# koneko-misc

Translated data.py and pure.py from [koneko](https://github.com/twenty5151/koneko) into Nim. For fun.

My thoughts on the languages

Language | Good | Bad | Ugly
--- | --- | --- | ---
Python | Easiest to use, looks the best | Kinda slow sometimes | Runtime errors are scary, compiler doesn't check for anything at all
Nim | Static type checking, small single executable binary, UFCS, looks nice too | Small community, lack of docs | Channels must be globals or use pointers to pass them. The effort & time needed to optimise it could have gone to writing more Python
Julia | Like Python but has piping macros. Faster for numerical stuff | Despite it being dynamically typed, it's really statically typed *and* compiled, making it slow for a dynamic, "interpreted" language | Compiling to an executable binary takes forever
Go | Best vim integration, single executable binary, static type checking | Channels deadlocking | No batteries included, need to write elementary functions like lst.index(), contains(), filter(). Syntax is archaic and Verbose, less than C/C++/C# but not by much. Worse thing is that its performance was comparable to Nim's, so it was more confusing than Nim without any speed benefits.
Elixir | Functional style (pipes, recursion, immutability) looks great and flows well. Built-in actor based concurrency. | `icat` doesn't work out of the box | Functional programming initially needs some time to get used to, `mix escript.build` for compiling to single binary is weird

Go is very opinionated, which isn't bad, but it's opinionated on relatively minor things while still being archaic in every other major thing
