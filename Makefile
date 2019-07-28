
.SECONDEXPANSION:

BINDIR = bin
OBJDIR = obj
SRCDIR = src

ASFLAGS = --auto-import --smart
LDFLAGS =

ASMS = $(wildcard $(SRCDIR)/*.asm)
INCS = $(wildcard $(SRCDIR)/*.inc) $(wildcard $(SRCDIR)/includes/*.inc) $(OBJDIR)/zp.inc
BIOSES = sgb1v1 sgb1v2

# We're required to substitute spaces for slashes later on, but just typing a space would cause it to get trimmed away
# So we instead define a variable containing a single space
SPACE =
SPACE +=


compare: sha256sums.txt all
	sha256sum -c $<
.PHONY: compare

all: $(patsubst %,$(BINDIR)/%.sfc,$(BIOSES))
.PHONY: all

clean:
	-rm -rf $(OBJDIR)
	-rm -rf $(BINDIR)
.PHONY: clean


# Config file must come first in order to be the argument of `--config`
$(BINDIR)/%.sfc: $(SRCDIR)/ld65.cfg $(patsubst $(SRCDIR)/%.asm,$(OBJDIR)/$$*/%.o,$(ASMS))
	@mkdir -p $(@D)
	ld65 $(LDFLAGS) -Ln $(@:.sfc=.cpu.sym) -o $@ --config $^ && $(SRCDIR)/fixchecksum.py $@

# Make is bugged and expands the patsubst before the `$*` or other automatic vars, even if doubling the patsubst's own dollar.
# This causes it to fail to match the literal `$*` string and not the var's contents.
# We're using a second-expanded variable to work around this,
# as its nature causes the patsubst to evaluate only when the variable is expanded, ie. at the second expansion.
BIOS_NAME = $(firstword $(subst /,$(SPACE),$*))
BASEBIOS = $(BIOS_NAME).sfc
ASMFILE  = $(patsubst $(BIOS_NAME)/%,$(SRCDIR)/%.asm,$*)
$(OBJDIR)/%.o: $$(ASMFILE) $(INCS) $$(BASEBIOS)
	@mkdir -p $(@D)
	@echo ".define BIOS_NAME \"$(BIOS_NAME)\"" > $(OBJDIR)/bios_name.inc
	ca65 $(ASFLAGS) -o $@ $<

$(OBJDIR)/zp.inc: $(SRCDIR)/zp.sh $(SRCDIR)/wram.asm
	@mkdir -p $(@D)
	$^ > $@

