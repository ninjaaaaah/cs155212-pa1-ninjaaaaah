# CS 155 21.2 Programming Assignment 1 (BF-to-MIPS Compiler)

Jarred Sueño E. Luzada

## Overview

### BF Programming Language

The BF programming language consists of a single 12-bit pointer with value referring to a single address in byte-addressable memory (i.e., the pointer points to a byte in memory).

BF source code consists of the following symbols:

- \> _(greater than)_ – Increments pointer value by 1

- < _(less than)_ – Decrements pointer value by 1

- \+ _(plus)_ – Increments byte pointed to by 1

- \- _(minus)_ – Decrements byte pointed to by 1

- . _(period)_ – Outputs ASCII equivalent of byte under pointer value

- , _(comma)_ – Sets byte pointed to 8-bit unsigned integer input of user

- [ _(opening bracket)_ – If byte pointed to is 0, continue processing starting from symbol after matching ]

- ] _(closing bracket)_ – If byte pointed to is not 0, continue processing starting from symbol after matching [

## Problem Statement

Create a F# program that _compiles_ BF source code into 32-bit MIPS assembly which is to be executed using the MARS MIPS simulator. The compiled MIPS assembly source code should be written to a file named `test.asm`.

### Input File

The compiler is expected to take in the path to a single file containing BF source code as a command line argument.

```
dotnet fsi .\main.fsx .\tests\4.bf
```

### Standard Output

Compilation success should output SUCCESS and generate the compiled MIPS file as test.asm. This can be executed via the following command:

```
java -jar mars.jar nc test.asm
```

macOS users may want to include -Dapple.awt.UIElement=true to prevent the MARS icon from appearing in the Dock during execution:

```
java -Dapple.awt.UIElement=true -jar mars.jar nc test.asm
```
