# eZ80 support for clang via the GNU assembler

Starting from https://github.com/jacobly0/llvm-project apply this patch and build using
something along the lines of:

    cmake -G Ninja -DLLVM_ENABLE_PROJECTS="clang" -DCMAKE_INSTALL_PREFIX=/opt/local/z80-none-elf -DCMAKE_BUILD_TYPE=Release -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=Z80 -DLLVM_TARGETS_TO_BUILD="" -DLLVM_DEFAULT_TARGET_TRIPLE=ez80-none-elf ../llvm

Compilation will require a few flags to succeed:

  - `-Wa,-march=ez80` will pass the approproate architecture flag to the GNU assembler
  - `-nostdinc` will prevent incorrect headers from being included


