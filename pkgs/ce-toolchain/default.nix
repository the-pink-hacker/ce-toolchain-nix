{
    stdenv,
    ce-toolchain-src,
    fasmg-patch,
    convbin-unstable,
    convimg,
    convfont,
    llvm-ez80,
    binutils-gdb,
    glibc,
}:
stdenv.mkDerivation {
    src = ce-toolchain-src;
    name = "ce-toolchain";
    patchPhase = ''
        substituteInPlace src/common.mk --replace-fail \
            "INSTALL_DIR := \$(patsubst %/,%,\$(subst \\,/,\$(DESTDIR)))/\$(PREFIX)" "INSTALL_DIR := $out"
        substituteInPlace makefile --replace-fail \
            "TOOLS := fasmg convbin convimg convfont cedev-config cedev-obj" \
            "TOOLS := fasmg cedev-config" \
            --replace-fail "\$(Q)\$(call COPY,\$(call NATIVEEXE,tools/convfont/convfont),\$(INSTALL_BIN))" "" \
            --replace-fail "\$(Q)\$(call COPY,\$(call NATIVEEXE,tools/convimg/bin/convimg),\$(INSTALL_BIN))" "" \
            --replace-fail "\$(Q)\$(call COPY,\$(call NATIVEEXE,tools/convbin/bin/convbin),\$(INSTALL_BIN))" "" \
            --replace-fail "\$(Q)\$(call COPY,\$(call NATIVEEXE,tools/cedev-obj/bin/cedev-obj),\$(INSTALL_BIN))" "" \
            --replace-fail "tools/convbin/bin/" "" \
            --replace-fail "--oformat 8xg-auto-extract" "--iformat 8x --oformat 8xg-auto-extract"
        substituteInPlace tools/convimg/Makefile tools/cedev-config/Makefile \
            --replace-fail "-static" ""
        substituteInPlace src/makefile.mk \
            --replace-fail "\$(call NATIVEPATH,\$(BIN)/convbin\$(EXE_SUFFIX))" "${convbin-unstable}/bin/convbin" \
            --replace-fail "\$(call NATIVEPATH,\$(BIN)/convimg\$(EXE_SUFFIX))" "${convimg}/bin/convimg" \
            --replace-fail "\$(call NATIVEPATH,\$(BIN)/cemu-autotester\$(EXE_SUFFIX))" "cemu-autotester" \
            --replace-fail "\$(call NATIVEPATH,\$(BIN)/ez80-clang\$(EXE_SUFFIX))" "${llvm-ez80}/bin/ez80-clang" \
            --replace-fail "\$(call NATIVEPATH,\$(BINUTILS_BIN)/z80-none-elf-as\$(EXE_SUFFIX))" "${binutils-gdb}/bin/z80-none-elf-as" \
            --replace-fail "\$(call NATIVEPATH,\$(BINUTILS_BIN)/z80-none-elf-ld\$(EXE_SUFFIX))" "${binutils-gdb}/bin/z80-none-elf-ld" \
            --replace-fail "\$(call NATIVEPATH,\$(BINUTILS_BIN)/z80-none-elf-objcopy\$(EXE_SUFFIX))" "${binutils-gdb}/bin/z80-none-elf-objcopy" \
            --replace-fail "\$(call NATIVEPATH,\$(BINUTILS_BIN)/z80-none-elf-strip\$(EXE_SUFFIX))" "${binutils-gdb}/bin/z80-none-elf-strip" \
            --replace-fail "CONVBINFLAGS += -b \$(call QUOTE_ARG,\$(COMMENT))" ""
    '';
    doCheck = true;
    enableParallelBuilding = true;
    buildInputs = [
        convimg
        convfont
        llvm-ez80
        fasmg-patch
        convbin-unstable
        binutils-gdb
        #glibc.static
    ];
    meta = {
        description = "Toolchain and libraries for C/C++ programming on the TI-84+ CE calculator series";
        #maintainers = with lib.maintainers; [clevor];
        mainProgram = "cedev-config";
        platforms = ["x86_64-linux" "x86_64-darwin"];
    };
}
