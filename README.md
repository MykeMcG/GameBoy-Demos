# GameBoy-Demos
A collection of various small programming demos for the Nintendo GameBoy.

## Demos

### hello_world
Your standard "Hello, World" program.
Displays the words "Hello, World" onscreen and nothing else.

### scroll
Scrolls the Nintendo logo vertically, wrapping it around until it shows up again.
Works best on actual hardware, or if your emulator supports showing the GameBoy's POST animation.

## Downloads
The latest compiled binaries can be downloaded from the [Releases page](https://github.com/MykeMcG/GameBoy-Demos/releases/latest).
Running the demos requires the use of either a GameBoy emulator, or a flash cart.

## Compiling
Before you can compile, make sure that the [RGBDS](https://github.com/rednex/rgbds) is in your PATH.
This repository includes a build task for Visual Studio Code, but you can compile it however you want.
Run the following commands from inside the `src` directory, replacing `<Demo Name>` with the name of the `.asm` file you wish to compile:
``` shell
rgbasm -o ../build/<Demo Name>.obj <Demo Name>.asm
rgblink -o ../build/<Demo Name>.gb ../build/<Demo Name>.obj
rgbfix -v -p0 ../build/<Demo Name>.gb
```

If you wanted to build the `hello_world` demo, for example, you would run the following commands:
``` shell
rgbasm -o ../build/hello_world.obj hello_world.asm
rgblink -o ../build/hello_world.gb ../build/hello_world.obj
rgbfix -v -p0 ../build/hello_world.gb
```

Once compiled, take the resulting `.gb` files and load them in your GameBoy emulator of choice, or put them on a flash cart.

## References
1. [DMGreport](https://github.com/lancekindle/DMGreport), lancekindle
2. [GBZ80 CPU instruction set description](https://rednex.github.io/rgbds/gbz80.7.html) *RGBDS — Rednex Game Boy Development System*, rednex