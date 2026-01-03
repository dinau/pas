### Pas

---

Simplified `pacman` command for MSys2/MinGW on Windows

- Notice:  
I'v not known `pacboy` command (included msys official `pactoys` package)[^pactoys],  
so it would be better to use `pacboy` command.

[^pactoys]: Install pactoys : `pacman -S pactoys`

### Usage: help

---

```sh
$ pas -h
[UCRT64] / Pas by Ruby 3.4.8
Usage:
  Update db and packages   : "pas"                 ---> pacman -Syu
  Search WORDs             : "pas WORD1 WORD2 ..." ---> pacman -Sl | grep -i WORD1 | grep -i WORD2 | ...
  Install package          : "pas -i  WORDs"       ---> pacman -S  mingw-w64-(kind)-x86_64-{WORD1,WORD2,..}
  Show package info        : "pas -ii WORDs"       ---> pacman -Si mingw-w64-(kind)-x86_64-{WORD1,WORD2,..}
  Uninstall package        : "pas -r  WORDs"       ---> pacman -Rc mingw-w64-(kind)-x86_64-{WORD1,WORD2,..}
  Clean downloded packages : "pas -c"              ---> pacman -Scc
  Help                     : "pas -h"              ---> /h, /?, --help are acceptable
```

### Prerequisites

---

1. [Ruby 3.x](https://rubyinstaller.org/downloads/) interpreter installed.

### Usage

#### pas : Update db and packages

---

```sh
$ pas
[UCRT64] / Pas by Ruby 3.4.8
pacman -Syu
:: Synchronizing package databases...
 clangarm64                                  502.6 KiB   272 KiB/s 00:02 [#######################################] 100%
 mingw32 is up to date
 mingw64                                     480.7 KiB   135 KiB/s 00:04 [#######################################] 100%
 ucrt64                                      528.4 KiB   172 KiB/s 00:03 [#######################################] 100%
 clang64                                     515.4 KiB   200 KiB/s 00:03 [#######################################] 100%
 msys is up to date
:: Starting core system upgrade...
 there is nothing to do
:: Starting full system upgrade...
 there is nothing to do
```

#### pas WORDs : Search package

---

1. Search by one word

   ```sh
   $ pas gcc

   [UCRT64] / Pas by Ruby 3.4.8
   mingw-w64-ucrt-x86_64-arm-none-eabi-gcc 13.3.0-1
   mingw-w64-ucrt-x86_64-avr-gcc 15.2.0-1
   mingw-w64-ucrt-x86_64-gcc 15.2.0-8 [installed]
   mingw-w64-ucrt-x86_64-gcc-ada 15.2.0-8
   mingw-w64-ucrt-x86_64-gcc-fortran 15.2.0-8
   mingw-w64-ucrt-x86_64-gcc-libgfortran 15.2.0-8
   mingw-w64-ucrt-x86_64-gcc-libs 15.2.0-8 [installed]
   mingw-w64-ucrt-x86_64-gcc-lto-dump 15.2.0-8
   mingw-w64-ucrt-x86_64-gcc-objc 15.2.0-8
   mingw-w64-ucrt-x86_64-libgccjit 15.2.0-8
   mingw-w64-ucrt-x86_64-python-pygccxml 3.0.2-1
   mingw-w64-ucrt-x86_64-riscv64-unknown-elf-gcc 15.1.0-2
   ```
1. Search by some words

   ```sh
   $ pas gcc arm
   
   [UCRT64] / Pas by Ruby 3.4.8
   mingw-w64-ucrt-x86_64-arm-none-eabi-gcc 13.3.0-1
   ```

   ```sh
   $ pas gcc avr
   [UCRT64] / Pas by Ruby 3.4.8
   mingw-w64-ucrt-x86_64-avr-gcc 15.2.0-1
   ```

#### pas -i WORDs : Install packages

---

```sh
$ pas -i sdl3-ttf

[UCRT64] / Pas by Ruby 3.4.8
pacman -S mingw-w64-ucrt-x86_64-{sdl3-ttf}
resolving dependencies...
looking for conflicting packages...
warning: dependency cycle detected:
warning: mingw-w64-ucrt-x86_64-harfbuzz will be installed before its mingw-w64-ucrt-x86_64-freetype dependency

Packages (6) mingw-w64-ucrt-x86_64-freetype-2.14.1-2  mingw-w64-ucrt-x86_64-glib2-2.86.3-1  mingw-w64-ucrt-x86_64-harfbuzz-12.2.0-2
             mingw-w64-ucrt-x86_64-python-3.12.12-1  mingw-w64-ucrt-x86_64-python-packaging-25.0-1
             mingw-w64-ucrt-x86_64-sdl3-ttf-3.2.2-3

Total Download Size:    31.40 MiB
Total Installed Size:  244.58 MiB

:: Proceed with installation? [Y/n]
```

#### pas -ii WORDs : Show package info

---

```sh
$ pas -ii sdl3

[UCRT64] / Pas by Ruby 3.4.8
pacman -Si mingw-w64-ucrt-x86_64-{sdl3}
Repository      : ucrt64
Name            : mingw-w64-ucrt-x86_64-sdl3
Version         : 3.2.28-1
Description     : A library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard (Version 3)
                  (mingw-w64)
Architecture    : any
URL             : https://libsdl.org/
Licenses        : spdx:Zlib
Groups          : None
Provides        : None
Depends On      : mingw-w64-ucrt-x86_64-cc-libs  mingw-w64-ucrt-x86_64-libiconv  mingw-w64-ucrt-x86_64-vulkan
Optional Deps   : None
Conflicts With  : None
Replaces        : None
Download Size   : 2.13 MiB
Installed Size  : 13.25 MiB
Packager        : CI (msys2/msys2-autobuild/8cbb808c/19892746920)
Build Date      : Wed Dec 3 20:53:43 2025
Validated By    : SHA-256 Sum
```
