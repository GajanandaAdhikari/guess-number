# 🎮 Guess the Number

![CI](https://github.com/GajanandaAdhikari/guess-number/actions/workflows/ci.yml/badge.svg)

A simple **C language game** where the computer picks a secret number and you try to guess it.
More than a toy project — this repo is a **template for structured C projects** with tests, cross-platform builds, and CI.

---

## 📚 Overview

This project demonstrates how to build a small but professional-grade C application:

* A **console game** where the player guesses a random number.
* A **portable Makefile** that works across Linux, macOS, and Windows (via MSYS2).
* **Unit tests** included and runnable with `make test`.
* **CI pipeline** (GitHub Actions) that builds and tests automatically across multiple OSes.
* Organized source, include, and test directories — ready to scale for larger projects.

---

## ✨ Features

* Command-line game logic in C
* Deterministic number generator for predictable test cases
* Debug & release build modes
* Unit test harness with sanitizers (Address + Undefined)
* Cross-compiler ready (ARM, MinGW, etc.)
* Continuous Integration with GitHub Actions (Linux, macOS, Windows)

---

## 📂 Project Structure

```
guess-number/
├── Makefile                  # Build system
├── include/                  # Header files
│   └── guess.h
├── src/                      # Source code
│   ├── main.c                # Game entry point
│   └── guess.c               # Game logic
├── tests/                    # Unit tests
│   └── test_guess.c
├── lib/                      # (Optional) external libraries
├── build/                    # Auto-generated build artifacts
│   ├── debug/
│   └── release/
└── .github/workflows/ci.yml  # CI pipeline
```

---

## 🛠️ Build & Run

### Prerequisites

* A C compiler (`gcc` or `clang`)
* `make`

### Build (Debug)

```bash
make
```

Produces binary at: `build/bin/guess`

### Build (Release)

```bash
make release
```

Produces optimized binary at: `build/bin/guess-0.1.0`

### Run the Game

```bash
./build/bin/guess
```

---

## ✅ Testing

Unit tests are included under `tests/`.
Run them with:

```bash
make test
```

Debug builds use sanitizers (`-fsanitize=address,undefined`) for safer development.

---

## 🔄 Continuous Integration

This project ships with a [GitHub Actions](.github/workflows/ci.yml) pipeline that:

* Builds the project on **Linux, macOS, Windows**
* Runs `make test` on each platform
* Uploads artifacts and logs on failure

Status badge:
![CI](https://github.com/GajanandaAdhikari/guess-number/actions/workflows/ci.yml/badge.svg)

---

## 🚀 Cross-Compilation

You can cross-compile for other targets by setting `CROSS_CC`:

```bash
make CROSS_CC=aarch64-linux-gnu-gcc release
make CROSS_CC=x86_64-w64-mingw32-gcc release
```

---

## 🌱 Future Ideas

* Add difficulty levels (different ranges).
* Add a scoring system based on attempts.
* Interactive menus and replay options.
* Port to SDL2 for a GUI version.

---

## 📜 License

MIT License — free to use, modify, and share.

---

## 👤 Author

**Gajananda Adhikari**

* 🌐 [LinkedIn](https://www.linkedin.com/in/gazananda)
* 🐙 [GitHub](https://github.com/GajanandaAdhikari)

---

💡 *“Secure, portable, and fun — that’s how systems should be built.”*

