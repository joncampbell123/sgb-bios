# Super Game Boy BIOS disassembly

This project aims to improve comprehension of the SGB BIOS, mainly by documenting its different routines, entry points, memory layout, etc, as well as providing symbols to help debugging SGB-SNES software.

# Dependencies

- ca65, which you can find as part of the cc65 compiler package
- Python 3
- sh or a compatible shell
- Make (must support `SECONDEXPANSION`, such as GNU Make)

# Usage

You will need copies of each BIOS you wish to build, called `sgb1v0.sfc`, `sgb1v1.sfc`, `sgb1v2.sfc`, `sgb2.sfc`, in the root folder.

Still in the root folder, type `make bin/<bios_name>.sfc` to compile a single BIOS ROM (names as noted above) or `make all` to build them all. `make compare`, the default target, ensures all compiled ROMs match the known SHA256 sums.

Output files will be placed in the `bin` folder, by default a VICE-format symbol file is also generated.

**Warning**: for now, only SGB1v1 and SGB1v2 are supported, as these are fairly close revisions; SGB1v0 and SGB2 will happen when progress with the former two is sufficient. (This also causes `make compare` to fail the comparison step as two files are missing; this will be solved when support is added, for now please only consider the output of each comparison.)

