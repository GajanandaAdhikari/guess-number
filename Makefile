# Makefile - portable, multi-target build for "guess the number" C project
# Usage:
#   make                -> build debug executable (default)
#   make release        -> build optimized release
#   make debug          -> explicit debug build
#   make test           -> build & run tests
#   make clean          -> remove build artifacts
#   make dist           -> create a tar.gz of release binary
# Environment knobs:
#   CC       -> C compiler (defaults: gcc or clang auto-detected)
#   TARGET   -> target triple name (optional)
#   CROSS_CC -> specify cross-compiler (e.g. aarch64-linux-gnu-gcc)
#   PREFIX   -> install prefix (default /usr/local)
#

# --------------------------------------------------
# Basic settings
# --------------------------------------------------
PACKAGE := guess-number
VERSION ?= 0.1.0

# Auto-detect compiler if not provided
ifeq ($(origin CC), default)
  ifeq ($(shell which clang 2>/dev/null),)
    CC := gcc
  else
    CC := clang
  endif
endif

# Allow explicit cross-compiler
ifdef CROSS_CC
  CC := $(CROSS_CC)
endif

# Directories
SRCDIR := src
INCDIR := include
TESTDIR := tests
BUILD := build
BINDIR := $(BUILD)/bin
DBGDIR := $(BUILD)/debug
RELDIR := $(BUILD)/release
LIBDIR := lib

# Files
TARGET := guess
LIBNAME := libguess.a

# Source lists (auto)
SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS_dbg := $(patsubst $(SRCDIR)/%.c,$(DBGDIR)/%.o,$(SRCS))
OBJS_rel := $(patsubst $(SRCDIR)/%.c,$(RELDIR)/%.o,$(SRCS))

# Compiler flags
CSTD := -std=c11
WARN := -Wall -Wextra -Wpedantic
INCLUDES := -I$(INCDIR)
LDFLAGS :=
LDLIBS :=

# Debug configuration
CFLAGS_dbg := $(CSTD) $(WARN) $(INCLUDES) -g -O0 -fno-omit-frame-pointer
CFLAGS_dbg += -DDEBUG
ASAN_FLAGS := -fsanitize=address,undefined -fno-sanitize-recover=all
CFLAGS_dbg += $(ASAN_FLAGS)
LDFLAGS_dbg := $(ASAN_FLAGS)

# Release configuration
CFLAGS_rel := $(CSTD) $(WARN) $(INCLUDES) -O2 -march=native -DNDEBUG
LDFLAGS_rel := -s

# Test flags (simple C assert-based tests)
CFLAGS_test := $(CFLAGS_dbg) -DTEST
LDFLAGS_test := $(LDFLAGS_dbg)

# Cross-compile convenience presets (examples)
# e.g. make CROSS_CC=aarch64-linux-gnu-gcc release
# or make CROSS_CC=x86_64-w64-mingw32-gcc release
# Users can set CROSS_CC before invoking make

# --------------------------------------------------
# Targets
# --------------------------------------------------
.PHONY: all debug release test clean dist install uninstall info

all: debug

# Debug build - default
debug: CFLAGS := $(CFLAGS_dbg)
debug: LDFLAGS := $(LDFLAGS_dbg)
debug: dirs $(DBGDIR)/$(LIBNAME) $(BINDIR)/$(TARGET)
	@echo "Debug build ready at $(BINDIR)/$(TARGET)"

# Release build
release: CFLAGS := $(CFLAGS_rel)
release: LDFLAGS := $(LDFLAGS_rel)
release: dirs $(RELDIR)/$(LIBNAME) $(BINDIR)/$(TARGET)-$(VERSION)
	@echo "Release build ready at $(BINDIR)/$(TARGET)-$(VERSION)"

# Test runner: compile tests and run
test: CFLAGS := $(CFLAGS_test)
test: LDFLAGS := $(LDFLAGS_test)
test: dirs $(DBGDIR)/test_runner
	@echo "Running unit tests..."
	@$(DBGDIR)/test_runner

# build directories
dirs:
	@mkdir -p $(BINDIR) $(DBGDIR) $(RELDIR)

# Static library creation (debug)
$(DBGDIR)/$(LIBNAME): $(OBJS_dbg)
	@ar rcs $@ $^
	@echo "Created $@"

# Static library creation (release)
$(RELDIR)/$(LIBNAME): $(OBJS_rel)
	@ar rcs $@ $^
	@echo "Created $@"

# Link debug binary
$(BINDIR)/$(TARGET): $(DBGDIR)/$(LIBNAME)
	$(CC) $(CFLAGS_dbg) $(LDFLAGS_dbg) -o $@ $(DBGDIR)/main.o $(DBGDIR)/guess.o $(LDFLAGS) $(LDLIBS)

# Link release binary (tagged)
$(BINDIR)/$(TARGET)-$(VERSION): $(RELDIR)/$(LIBNAME)
	$(CC) $(CFLAGS_rel) $(LDFLAGS_rel) -o $@ $(RELDIR)/main.o $(RELDIR)/guess.o $(LDFLAGS) $(LDLIBS)

# Simple rule to build test runner
$(DBGDIR)/test_runner: $(DBGDIR)/guess.o $(TESTDIR)/test_guess.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# Compile objects (debug)
$(DBGDIR)/%.o: $(SRCDIR)/%.c $(INCDIR)/%.h | dirs
	$(CC) $(CFLAGS) -c $< -o $@

# Compile objects (release)
$(RELDIR)/%.o: $(SRCDIR)/%.c $(INCDIR)/%.h | dirs
	$(CC) $(CFLAGS) -c $< -o $@

# Compile test object
$(TESTDIR)/%.o: $(TESTDIR)/%.c $(INCDIR)/%.h | dirs
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	@rm -rf $(BUILD)
	@echo "Cleaned build artifacts."

# Dist (tarball of release)
dist: release
	@mkdir -p dist
	@tar -czf dist/$(PACKAGE)-$(VERSION).tar.gz -C $(BINDIR) $(TARGET)-$(VERSION)
	@echo "Created dist/$(PACKAGE)-$(VERSION).tar.gz"

# Install (basic)
install: release
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BINDIR)/$(TARGET)-$(VERSION) $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "Installed to $(DESTDIR)$(PREFIX)/bin/$(TARGET)"

uninstall:
	@rm -f $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "Uninstalled $(TARGET)"

# Show info
info:
	@echo "Compiler: $(CC)"
	@echo "CFLAGS (debug): $(CFLAGS_dbg)"
	@echo "CFLAGS (release): $(CFLAGS_rel)"
	@echo "Build dirs: $(BUILD)"
	@echo "Targets: debug release test clean dist install"


