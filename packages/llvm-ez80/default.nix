{
    stdenv,
    llvm-ez80-src,
    cmake,
    python3,
    lib,
}:
stdenv.mkDerivation (final: {
    pname = "llvm-ez80";
    version = "0-unstable";
    src = llvm-ez80-src;
    configurePhase = ''
        mkdir build
        cd build
        cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang -DLLVM_TARGETS_TO_BUILD= -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=Z80
        cd ..
    '';
    buildPhase = ''
        cd build
        cmake --build . --target clang llvm-link -j $NIX_BUILD_CORES
        cd ..
    '';
    installPhase = ''
        mkdir -p $out/bin
        cp build/bin/clang $out/bin/ez80-clang
        cp build/bin/llvm-link $out/bin/ez80-link
    '';
    meta = {
        description = "A compiler and linker for (e)Z80 targets.";
        longDescription = ''
            This package provides a compiler and linker for (e)Z80 targets
            based on the LLVM toolchain.
            Originally designed for the TI-84 Plus CE, this also works for the Agon Light.

            This does not provide fasmg or any include files to build the programs.
            Please install a toolchain, such as the CE C toolchain.
        '';
        homepage = "https://github.com/jacobly0/llvm-project";
        #license = lib.licenses.asl20-llvm;
        #maintainers = with lib.maintainers; [clevor];
        platforms = lib.platforms.unix;
    };
    doCheck = false;
    nativeBuildInputs = [cmake python3];
})
