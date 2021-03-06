FROM buildpack-deps:stable

RUN apt-get update && apt-get -y install cmake ninja-build lzip
#RUN useradd -ms /bin/bash ez80
#USER ez80
WORKDIR /root
COPY clang/0001-Emit-GAS-sytax.patch 0001-Emit-GAS-sytax.patch
RUN curl -LO https://github.com/jacobly0/llvm-project/archive/1b767f5cc455.zip
RUN unzip 1b767f5cc455.zip
RUN cd llvm-project-1b767f5cc45505fb2d6285e717d439c6b1ea2e7f && patch -p1 < ../0001-Emit-GAS-sytax.patch
RUN cd llvm-project-1b767f5cc45505fb2d6285e717d439c6b1ea2e7f \
    && mkdir build \
    && cmake -G Ninja -DLLVM_ENABLE_PROJECTS="clang" \
                      -DCMAKE_INSTALL_PREFIX=/opt/local/ez80-none-elf \
                      -DCMAKE_BUILD_TYPE=Release \
                      -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=Z80 \
                      -DLLVM_TARGETS_TO_BUILD= \
                      -DLLVM_DEFAULT_TARGET_TRIPLE=ez80-none-elf \
                      ../llvm-project-1b767f5cc45505fb2d6285e717d439c6b1ea2e7f/llvm \
    && ninja install
RUN curl -LO https://mirror.freedif.org/GNU/binutils/binutils-2.36.1.tar.lz
RUN tar xf binutils-2.36.1.tar.lz
RUN cd binutils-2.36.1 \
    && ./configure --target=z80-none-elf --program-prefix=ez80-none-elf- --prefix=/opt/local/ez80-none-elf \
    && make -j4 \
    && make install
