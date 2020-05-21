# koneko-misc

Translated data.py and pure.py from [koneko](https://github.com/twenty5151/koneko) into Nim. For fun.

My thoughts on the languages

. | Python | Nim | Julia | Go
--- | --- | --- | --- | ---
Good | Easiest to use, looks the best | Static type checking, small single executable binary, UFCS, looks nice too | Like Python but has piping macros. Faster for numerical stuff | Best vim integration, single executable binary
Bad | Kinda slow sometimes | Small community | Despite it being dynamically typed, it's really statically typed *and* compiled. REPL is slow | Channels deadlocking
Ugly | Runtime errors are scary, compiler doesn't check for anything at all | The effort & time needed to optimise it could have gone to writing more Python | Compiling to an executable binary takes forever | No batteries included, need to write elementary functions like lst.index(), contains(), filter(). Syntax is archaic and Verbose, less than C/C++/C# but not by much. Worse thing is that its performance was comparable to Nim's, so it was more confusing than Nim without any speed benefits.
