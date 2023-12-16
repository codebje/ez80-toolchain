FROM buildpack-deps:stable

RUN apt-get update && apt-get -y install cmake ninja-build lzip
#RUN useradd -ms /bin/bash ez80
#USER ez80
WORKDIR /root
COPY clang/0001-Emit-GAS-sytax.patch 0001-Emit-GAS-sytax.patch
RUN curl -LO https://github.com/jacobly0/llvm-project/archive/005a99ce256937.zip
RUN unzip 005a99ce256937.zip
RUN cd llvm-project-005a99ce2569373524bd881207aa4a1e98a2b238 && patch -p1 < ../0001-Emit-GAS-sytax.patch
RUN cd llvm-project-005a99ce2569373524bd881207aa4a1e98a2b238 \
    && mkdir build \
    && cmake -G Ninja -DLLVM_ENABLE_PROJECTS="clang" \
                      -DCMAKE_INSTALL_PREFIX=/opt/local/ez80-none-elf \
                      -DCMAKE_BUILD_TYPE=Release \
                      -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=Z80 \
                      -DLLVM_TARGETS_TO_BUILD= \
                      -DLLVM_DEFAULT_TARGET_TRIPLE=ez80-none-elf \
                      ../llvm-project-005a99ce2569373524bd881207aa4a1e98a2b238/llvm \
    && ninja install
RUN curl -LO https://mirror.freedif.org/GNU/binutils/binutils-2.36.1.tar.lz
RUN tar xf binutils-2.36.1.tar.lz
RUN cd binutils-2.36.1 \
    && ./configure --target=z80-none-elf --program-prefix=ez80-none-elf- --prefix=/opt/local/ez80-none-elf \
    && make -j4 \
    && make install

FROM buildpack-deps:stable
COPY --from=0 /opt/local/ez80-none-elf /opt/local/ez80-none-elf
ENV PATH=/opt/local/ez80-none-elf/bin:$PATH
