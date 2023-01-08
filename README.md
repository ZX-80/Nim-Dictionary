<div align="center">

# Nim-Dictionary

![badge](https://badgen.net/badge/version/v1.0.1/orange?style=flat-square)
![badge](https://badgen.net/badge/platform/Windows/green?style=flat-square)
![badge](https://badgen.net/badge/Nim/1.6.10/yellow?style=flat-square)

<p align = "center">
  <img width="300px" src="Images/nim_dict.png">
</p>

A terminal dictionary based on the Online Plain Text English Dictionary

(based on the Project Gutenberg Etext of Webster's Unabridged Dictionary, which is based on the 1913 US Webster's Unabridged Dictionary)

[How to Use](#how-to-use) •
[Building](#building)

</div>

# How to Use

Simply type the command `def` with the word you want defined

```
> def nim
Nim
 1. (v. t.) To take; to steal; to filch.
```

If the word is not found, you will get some suggestions for similar words that do exist

```
> def nimrod
No match found.
Did you mean: Nimmed, Nitro, Nitrol, Ramrod, Aimed, Aired, Bird, Birred, Citron, Dimmed
```

# Building

Compile using the [Nim compiler](https://nim-lang.org/), and the flags of your choosing. For example

```
> nim c -d:release def.nim
```